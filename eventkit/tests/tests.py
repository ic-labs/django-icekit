"""
Tests for ``eventkit`` app.
"""

# WebTest API docs: http://webtest.readthedocs.org/en/latest/api.html

from datetime import datetime, timedelta
import six

from django.conf import settings
from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError
from django.core.management import call_command
from django.core.urlresolvers import reverse
from django.forms.models import fields_for_model
from django.test.utils import override_settings
from django.utils import timezone
from django_dynamic_fixture import G
from django_webtest import WebTest

from eventkit import appsettings, forms, models, views
from eventkit.utils import time
from eventkit.tests import models as test_models


class Admin(WebTest):
    def setUp(self):
        self.User = get_user_model()
        self.superuser = G(self.User)
        self.superuser.set_password('abc123')
        self.client.login(**{
            self.User.USERNAME_FIELD: self.superuser.get_username(),
            'password': 'abc123',
        })

    def test_urls(self):
        self.app.get(reverse('admin:eventkit_recurrencerule_changelist'))


class Forms(WebTest):
    def test_RecurrenceRuleField(self):
        """
        Test validation.
        """
        # Incomplete.
        message = 'Enter a complete value.'
        with self.assertRaisesMessage(ValidationError, message):
            forms.RecurrenceRuleField().clean([1, None])

        # Invalid.
        message = 'Enter a valid iCalendar (RFC2445) recurrence rule.'
        with self.assertRaisesMessage(ValidationError, message):
            forms.RecurrenceRuleField().clean([None, 'foo'])


class Migrations(WebTest):
    def test_eventkit_backwards(self):
        """
        Test backwards migrations.
        """
        call_command('migrate', 'eventkit', 'zero')
        call_command('migrate', 'eventkit')

    def test_eventkit_sample_data(self):
        """
        Test ``sample_data`` migrations.
        """
        INSTALLED_APPS = settings.INSTALLED_APPS + ('eventkit.sample_data', )
        with override_settings(INSTALLED_APPS=INSTALLED_APPS):
            call_command('migrate', 'eventkit_sample_data')
            call_command('migrate', 'eventkit_sample_data', 'zero')


class Models(WebTest):
    def test_BaseModel(self):
        """
        Test that ``modified`` field is updated on save.
        """
        obj = G(test_models.BaseModel)
        modified = obj.modified
        obj.save()
        self.assertNotEqual(obj.modified, modified)

    def test_RecurrenceRuleField(self):
        """
        Test form field and validators.
        """
        # Form field.
        fields = fields_for_model(models.Event)
        self.assertIsInstance(
            fields['recurrence_rule'], forms.RecurrenceRuleField)

        # Validation.
        event = models.Event(recurrence_rule='foo')
        message = 'Enter a valid iCalendar (RFC2445) recurrence rule.'
        with self.assertRaisesMessage(ValidationError, message):
            event.full_clean()

    def test_Event_clean(self):
        """
        Test model validation.
        """
        now = timezone.now()
        recurrence_rule = 'FREQ=DAILY'

        # Do not unset `end_repeat` when a recurrence rule is set.
        event = G(
            models.Event,
            recurrence_rule=recurrence_rule,
            end_repeat=now,
        )
        event.full_clean()
        self.assertEqual(event.end_repeat, now)

        # Unset `end_repeat` if no recurrence rule is set.
        event.recurrence_rule = None
        event.full_clean()
        self.assertEqual(event.end_repeat, None)

    def test_Event_change_detection(self):
        """
        Test that changes to event repeat fields are detected.
        """
        # Create an event.
        event = G(models.Event)
        self.assertFalse(event._monitor_fields_changed())
        # Change a field.
        event.title = 'title'
        # Check for changes in all fields and specific fields, given as string
        # and list values.
        self.assertTrue(event._monitor_fields_changed())
        self.assertTrue(event._monitor_fields_changed('title'))
        self.assertFalse(event._monitor_fields_changed('recurrence_rule'))
        self.assertTrue(event._monitor_fields_changed(
            ['title', 'recurrence_rule']))

    def test_Event_is_repeat(self):
        event = G(models.Event, recurrence_rule='FREQ=DAILY')
        # Original is not a repeat.
        self.assertFalse(event.is_repeat())
        # Repeat events are.
        self.assertTrue(event.get_repeat_events().first().is_repeat())

    def test_Event_str(self):
        event = G(models.Event, title='title')
        self.assertEqual(six.text_type(event), 'title')


class TestEventPropagation(WebTest):
    def setUp(self):
        """
        Create 20 events with a daily recurrence rule.
        """
        # Set `end_repeat` to 19 days after the first event starts, so we have
        # 20 events in total.
        starts = time.round_datetime(
            when=timezone.now(),
            precision=timedelta(days=1),
            rounding=time.ROUND_DOWN)
        ends = starts + appsettings.DEFAULT_ENDS_DELTA
        end_repeat = starts + timedelta(days=19)

        # Repeat events are created automatically for new events.
        self.event = G(
            models.Event,
            title='event',
            starts=starts,
            ends=ends,
            recurrence_rule='FREQ=DAILY',
            end_repeat=end_repeat,
        )

    def test_create_repeat_events(self):
        # Repeat events are created automatically for new events.
        self.assertEqual(models.Event.objects.count(), 20)

    def test_get_repeat_events(self):
        # Repeat events queryset does not include the event being repeated.
        self.assertEqual(self.event.get_repeat_events().count(), 19)

    def test_save_no_change(self):
        # Saving without making changes does not decouple or propagate.
        self.event.get_repeat_events()[10].save()
        self.assertEqual(self.event.get_repeat_events().count(), 19)

    def test_decouple(self):
        # Decouple events by changing any monitored fields. Changes are not
        # propagated. The recurrence rule is automatically removed.
        event2 = self.event.get_repeat_events()[10]
        event2.title = 'title'
        event2.save()
        # Original repeat events reduced by 1.
        self.assertEqual(self.event.get_repeat_events().count(), 18)
        # Decoupled, so no repeat events.
        self.assertEqual(event2.get_repeat_events().count(), 0)
        # Same total number of events.
        self.assertEqual(models.Event.objects.count(), 20)
        # No recurrence rule.
        self.assertIsNone(event2.recurrence_rule)

    def test_decouple_and_delete(self):
        # To decouple and delete repeat events, remove the recurrence rule and
        # call `save(propagate=True)`.
        event2 = self.event.get_repeat_events()[10]
        event2.recurrence_rule = None
        event2.save(propagate=True)
        # Original repeat events reduced by 9. (19 less 10 kept.)
        self.assertEqual(self.event.get_repeat_events().count(), 10)
        # Decoupled, so no repeat events.
        self.assertEqual(event2.get_repeat_events().count(), 0)
        # Total number of events reduced by 8. (20 days less 10 repeats kept
        # less 2 originals.)
        self.assertEqual(models.Event.objects.count(), 12)

    def test_update_recurrence_rule(self):
        # Updating the recurrence rule without propagating is not allowed.
        # Decoupled events cannot repeat.
        event2 = self.event.get_repeat_events()[10]
        event2.recurrence_rule = 'FREQ=WEEKLY'
        message = (
            'Cannot update recurrence rule without propagating changes to '
            'repeat events.')
        with self.assertRaisesMessage(AssertionError, message):
            event2.save()

    def test_remove_recurrence_rule(self):
        # Removing the recurrence rule without making any other changes is not
        # allowed. This would be a no-op.
        event2 = self.event.get_repeat_events()[10]
        event2.recurrence_rule = None
        message = (
            'Cannot decouple event without any substantive changes. Removing '
            'the recurrence rule alone is a no-op.')
        with self.assertRaisesMessage(AssertionError, message):
            event2.save()

    def test_propagate(self):
        # To propagate, call `save(propagate=True)`. Repeat events will be
        # updated when the repeat occurrences are not changed.
        event2 = self.event.get_repeat_events()[10]
        pks = set(event2.get_repeat_events().values_list('pk', flat=True))
        event2.title = 'title'
        event2.save(propagate=True)
        # Original repeat events reduced by 9. (19 less 10 kept.)
        self.assertEqual(self.event.get_repeat_events().count(), 10)
        # Propagated. 8 repeat events (9 decoupled less 1 new original.)
        self.assertEqual(event2.get_repeat_events().count(), 8)
        # Same total number of events.
        self.assertEqual(models.Event.objects.count(), 20)
        # Same primary keys for updated repeat events.
        self.assertFalse(pks.difference(set(
            event2.get_repeat_events().values_list('pk', flat=True))))

    def test_propagate_start_time(self):
        # To propagate, call `save(propagate=True)`. Repeat events will be
        # recreated when the repeat occurrences are changed (start time).
        event2 = self.event.get_repeat_events()[10]
        pks = set(event2.get_repeat_events().values_list('pk', flat=True))
        event2.starts -= timedelta(minutes=30)
        event2.save(propagate=True)
        # Original repeat events reduced by 9. (19 less 10 kept.)
        self.assertEqual(self.event.get_repeat_events().count(), 10)
        # Propagated. 8 daily repeat events (20 days less 10 repeats kept less
        # 2 originals.)
        self.assertEqual(event2.get_repeat_events().count(), 8)
        # Same total number of events.
        self.assertEqual(models.Event.objects.count(), 20)
        # New primary keys for recreated repeat events.
        self.assertFalse(pks.intersection(set(
            event2.get_repeat_events().values_list('pk', flat=True))))

    def test_propagate_recurrence_rule(self):
        # To propagate, call `save(propagate=True)`. Repeat events will be
        # recreated when the repeat occurrences are changed (recurrence rule).
        event2 = self.event.get_repeat_events()[3]
        pks = set(event2.get_repeat_events().values_list('pk', flat=True))
        event2.recurrence_rule = 'FREQ=WEEKLY'
        event2.save(propagate=True)
        # Original repeat events reduced by 16. (19 less 3 kept.)
        self.assertEqual(self.event.get_repeat_events().count(), 3)
        # Propagated. 2 weekly repeat events (20 days less 3 repeats kept less
        # 2 originals.)
        self.assertEqual(event2.get_repeat_events().count(), 2)
        # Total number of events reduced by 13. (16 repeats less 1 decoupled
        # less 2 recreated.)
        self.assertEqual(models.Event.objects.count(), 7)
        # New primary keys for recreated repeat events.
        self.assertFalse(pks.intersection(set(
            event2.get_repeat_events().values_list('pk', flat=True))))

    def test_create_missing_events(self):
        # Delete a few repeat events to simulate "missing" events and recreate.
        self.assertEqual(len(self.event.missing_repeat_events), 0)
        models.Event.objects \
            .filter(pk__in=self.event.get_repeat_events()[5:]) \
            .delete()
        self.assertEqual(len(self.event.missing_repeat_events), 14)
        self.event.create_repeat_events()
        self.assertEqual(len(self.event.missing_repeat_events), 0)
        self.assertEqual(self.event.get_repeat_events().count(), 19)
        self.assertEqual(models.Event.objects.count(), 20)


class Views(WebTest):
    def test_index(self):
        response = self.app.get(reverse('eventkit_index'))
        response.mustcontain('Hello World')


class Time(WebTest):
    def test_round_datetime(self):
        m = 60
        h = m * 60
        d = h * 24
        # Input, output, precision, rounding.
        data = (
            # Round nearest.
            ((1999, 12, 31, 0, 0, 29), (1999, 12, 31, 0, 0, 0), m, time.ROUND_NEAREST),
            ((1999, 12, 31, 0, 0, 30), (1999, 12, 31, 0, 1, 0), m, time.ROUND_NEAREST),
            # Round up and down.
            ((1999, 12, 31, 0, 0, 29), (1999, 12, 31, 0, 1, 0), m, time.ROUND_UP),
            ((1999, 12, 31, 0, 0, 30), (1999, 12, 31, 0, 0, 0), m, time.ROUND_DOWN),
            # Strip microseconds.
            ((1999, 12, 31, 0, 0, 30, 999), (1999, 12, 31, 0, 1, 0), m, time.ROUND_NEAREST),
            # Timedelta as precision.
            ((1999, 12, 31, 0, 0, 30), (1999, 12, 31, 0, 1, 0), timedelta(seconds=m), time.ROUND_NEAREST),
            # Precisions: 5, 10, 15 20, 30 minutes, 1, 12 hours, 1 day.
            ((1999, 12, 31, 0, 2, 30), (1999, 12, 31, 0, 5, 0), m * 5, time.ROUND_NEAREST),
            ((1999, 12, 31, 0, 5, 0), (1999, 12, 31, 0, 10, 0), m * 10, time.ROUND_NEAREST),
            ((1999, 12, 31, 0, 7, 30), (1999, 12, 31, 0, 15, 0), m * 15, time.ROUND_NEAREST),
            ((1999, 12, 31, 0, 10, 0), (1999, 12, 31, 0, 20, 0), m * 20, time.ROUND_NEAREST),
            ((1999, 12, 31, 0, 15, 0), (1999, 12, 31, 0, 30, 0), m * 30, time.ROUND_NEAREST),
            ((1999, 12, 31, 0, 30, 0), (1999, 12, 31, 1, 0, 0), h, time.ROUND_NEAREST),
            ((1999, 12, 31, 6, 0, 0), (1999, 12, 31, 12, 0, 0), h * 12, time.ROUND_NEAREST),
            ((1999, 12, 31, 12, 0, 0), (2000, 1, 1, 0, 0, 0), d, time.ROUND_NEAREST),
            # Weekday as precision. 3 Jan 2000 = Monday.
            ((1999, 12, 30, 12, 0, 0), (2000, 1, 3, 0, 0, 0), time.MON, time.ROUND_NEAREST),
            ((1999, 12, 31, 12, 0, 0), (2000, 1, 4, 0, 0, 0), time.TUE, time.ROUND_NEAREST),
            ((2000, 1, 1, 12, 0, 0), (2000, 1, 5, 0, 0, 0), time.WED, time.ROUND_NEAREST),
            ((2000, 1, 2, 12, 0, 0), (2000, 1, 6, 0, 0, 0), time.THU, time.ROUND_NEAREST),
            ((2000, 1, 3, 12, 0, 0), (2000, 1, 7, 0, 0, 0), time.FRI, time.ROUND_NEAREST),
            ((2000, 1, 4, 12, 0, 0), (2000, 1, 8, 0, 0, 0), time.SAT, time.ROUND_NEAREST),
            ((2000, 1, 5, 12, 0, 0), (2000, 1, 9, 0, 0, 0), time.SUN, time.ROUND_NEAREST),
        )
        for dt1, dt2, precision, rounding in data:
            self.assertEqual(
                time.round_datetime(datetime(*dt1), precision, rounding),
                datetime(*dt2))
