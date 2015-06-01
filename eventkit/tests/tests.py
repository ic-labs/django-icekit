"""
Tests for ``eventkit`` app.
"""

# WebTest API docs: http://webtest.readthedocs.org/en/latest/api.html

from datetime import datetime, timedelta

from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError
from django.core.urlresolvers import reverse
from django.utils import timezone
from django_dynamic_fixture import G
from django_webtest import WebTest

from eventkit import forms, models, settings, views
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
    def test(self):
        pass


class Models(WebTest):
    def test_BaseModel(self):
        """
        Test that ``modified`` field is updated on save.
        """
        obj = G(test_models.BaseModel)
        modified = obj.modified
        obj.save()
        self.assertNotEqual(obj.modified, modified)

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

    def test_Event_propagation(self):
        """
        Test repeat event propagation.
        """
        # Set `end_repeat` to 19 days after the first event starts, so we have
        # 20 events in total.
        starts = time.round_datetime(
            when=timezone.now(),
            precision=timedelta(days=1),
            rounding=time.ROUND_DOWN)
        ends = starts + settings.DEFAULT_ENDS_DELTA
        end_repeat = starts + timedelta(days=19)

        # Get a recurrence rule to use.
        recurrence_rule = 'FREQ=DAILY'

        # Start with no events.
        self.assertEqual(models.Event.objects.count(), 0)

        # Create an event with a daily recurrence rule. Repeat events are
        # created automatically.
        event = G(
            models.Event,
            title='event',
            starts=starts,
            ends=ends,
            recurrence_rule=recurrence_rule,
            end_repeat=end_repeat,
        )
        self.assertEqual(event.get_repeat_events().count(), 19)  # 20d - e1
        self.assertEqual(models.Event.objects.count(), 20)  # e1+19r

        # Saving without making changes doesn't propagate anything.
        event.save()
        self.assertEqual(event.get_repeat_events().count(), 19)
        self.assertEqual(models.Event.objects.count(), 20)

        # Delete a few repeat events and recreate to simulate the extension of
        # events that repeat further into the than the configured limit.
        self.assertEqual(len(event.missing_repeat_events), 0)
        models.Event.objects \
            .filter(pk__in=event.get_repeat_events()[15:]) \
            .delete()
        self.assertEqual(len(event.missing_repeat_events), 4)
        event.create_repeat_events()
        self.assertEqual(len(event.missing_repeat_events), 0)

        # Removing a recurrence rule will not propagate by default.
        event2 = event.get_repeat_events()[15]
        # event2.title = 'event 2'
        event2.recurrence_rule = None
        event2.save()
        self.assertEqual(event.get_repeat_events().count(), 18)  # r19 - e2
        self.assertEqual(event2.get_repeat_events().count(), 0)
        self.assertEqual(models.Event.objects.count(), 20)  # e1+18r + e2

        # To remove a recurrence rule and delete repeat events, pass
        # `propagate=True` to `save()`.
        event3 = event.get_repeat_events()[10]
        # event3.title = 'event 3'
        event3.recurrence_rule = None
        event3.save(propagate=True)
        self.assertEqual(event.get_repeat_events().count(), 10)  # r18 - e3+7r
        self.assertEqual(event2.get_repeat_events().count(), 0)
        self.assertEqual(event3.get_repeat_events().count(), 0)
        self.assertEqual(models.Event.objects.count(), 13)  # e1+10r + e2 + e3

        # Changes to recurrence rule are always propagated.
        event4 = event.get_repeat_events()[5]
        # event4.title = 'event 4'
        event4.recurrence_rule = 'FREQ=DAILY;INTERVAL=2'
        event4.save()
        self.assertEqual(event.get_repeat_events().count(), 5)  # 10r - e4+4r
        self.assertEqual(event2.get_repeat_events().count(), 0)
        self.assertEqual(event3.get_repeat_events().count(), 0)
        self.assertEqual(event4.get_repeat_events().count(), 6)  # 20d - e1+5r = 14d / 2 - e4
        self.assertEqual(models.Event.objects.count(), 15)  # e1+5r, e2, e3, e4+6r

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
