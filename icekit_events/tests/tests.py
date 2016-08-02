"""
Tests for ``icekit_events`` app.
"""

# WebTest API docs: http://webtest.readthedocs.org/en/latest/api.html

from timezone import timezone
from datetime import datetime, timedelta
import six

from django.conf import settings
from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError
from django.core.management import call_command
from django.core.urlresolvers import reverse
from django.forms.models import fields_for_model
from django.test import TestCase
from django.test.utils import override_settings
from django_dynamic_fixture import G, N
from django_webtest import WebTest

from icekit_events import appsettings, forms, models
from icekit_events.models import get_occurrences_start_datetimes_for_event
from icekit_events.tests import models as test_models
from icekit_events.utils import time


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
        self.app.get(reverse('admin:icekit_events_recurrencerule_changelist'))


class Forms(TestCase):

    def test_RecurrenceRuleField(self):
        """
        Test validation.
        """
        # Incomplete.
        message = 'Enter a complete value.'
        with self.assertRaisesMessage(ValidationError, message):
            forms.RecurrenceRuleField().clean([1, None, None])

        # Invalid.
        message = 'Enter a valid iCalendar (RFC2445) recurrence rule.'
        with self.assertRaisesMessage(ValidationError, message):
            forms.RecurrenceRuleField().clean([None, None, 'foo'])


class Migrations(TestCase):

    def test_icekit_events_backwards(self):
        """
        Test backwards migrations.
        """
        call_command('migrate', 'icekit_events', 'zero')
        call_command('migrate', 'icekit_events')

    def test_icekit_events_sample_data(self):
        """
        Test ``sample_data`` migrations.
        """
        INSTALLED_APPS = settings.INSTALLED_APPS + ('icekit_events.sample_data', )
        with override_settings(INSTALLED_APPS=INSTALLED_APPS):
            call_command('migrate', 'icekit_events_sample_data')
            call_command('migrate', 'icekit_events_sample_data', 'zero')


class TestRecurrenceRule(TestCase):

    def test_str(self):
        recurrence_rule = G(
            models.RecurrenceRule,
            description='description',
            recurrence_Rule='FREQ=DAILY',
        )
        self.assertEqual(six.text_type(recurrence_rule), 'description')


class TestEventModel(TestCase):

    def setUp(self):
        self.start = time.round_datetime(
            when=timezone.now(),
            precision=timedelta(minutes=1),
            rounding=time.ROUND_DOWN)
        self.end = self.start

    def test_basemodel_modified(self):
        """
        Test that ``modified`` field is updated on save.
        """
        obj = G(test_models.BaseModel)
        modified = obj.modified
        obj.save()
        self.assertNotEqual(obj.modified, modified)

    def test_str(self):
        event = G(
            models.Event,
            title="Event title",
        )
        occurrence = models.Occurrence(event=event)
        self.assertTrue('"Event title"' in six.text_type(occurrence))

    def test_derived_from(self):
        # Original is originating event for itself.
        event = G(models.Event)
        G(
            models.EventRepeatsGenerator,
            event=event,
            start=self.start,
            end=self.start,
            recurrence_rule='FREQ=DAILY',
        )
        self.assertIsNone(event.derived_from)
        # Variation is derived from original event
        variation = event.make_variation(
            event.occurrences.all()[6])
        variation.title = 'Variation'
        variation.save()
        self.assertNotEqual(event.pk, variation.pk)
        self.assertEqual(event, variation.derived_from)

    def test_event_without_occurrences(self):
        event = G(models.Event)
        self.assertEqual(0, event.occurrences.all().count())


class TestEventRepeatsGeneratorModel(TestCase):

    def setUp(self):
        """ Create a daily recurring event with no end date """
        self.start = time.round_datetime(
            when=timezone.now(),
            precision=timedelta(days=1),
            rounding=time.ROUND_DOWN)
        self.end = self.start + appsettings.DEFAULT_ENDS_DELTA

    def test_uses_recurrencerulefield(self):
        """
        Test form field and validators.
        """
        # Form field.
        fields = fields_for_model(models.EventRepeatsGenerator)
        self.assertIsInstance(
            fields['recurrence_rule'], forms.RecurrenceRuleField)

        # Validation.
        generator = models.EventRepeatsGenerator(recurrence_rule='foo')
        message = 'Enter a valid iCalendar (RFC2445) recurrence rule.'
        with self.assertRaisesMessage(ValidationError, message):
            generator.full_clean()

    def test_save_checks(self):
        # End cannot come before start
        try:
            models.EventRepeatsGenerator(
                start=self.start,
                end=self.start - timedelta(seconds=1),
            ).save()
            self.fail("Expected GeneratorException")
        except models.GeneratorException, ex:
            self.assertTrue(
                'End date/time must be after or equal to start date/time:'
                in ex.message)
        # End can equal start
        generator = models.EventRepeatsGenerator(
            start=self.start,
            end=self.start,
            event=G(models.Event),
        )
        generator.save()  # Check it passes ``save()`` tests
        self.assertEqual(timedelta(), generator.duration)
        # Repeat end cannot be set without a recurrence rule
        try:
            models.EventRepeatsGenerator(
                start=self.start,
                end=self.start + timedelta(seconds=1),
                repeat_end=self.start + timedelta(seconds=1)
            ).save()
            self.fail("Expected GeneratorException")
        except models.GeneratorException, ex:
            self.assertTrue(
                'Recurrence rule must be set if a repeat end date/time is set'
                in ex.message)
        # Repeat end cannot come before start
        try:
            models.EventRepeatsGenerator(
                start=self.start,
                end=self.start + timedelta(seconds=1),
                recurrence_rule='FREQ=DAILY',
                repeat_end=self.start - timedelta(seconds=1)
            ).save()
            self.fail("Expected GeneratorException")
        except models.GeneratorException, ex:
            self.assertTrue(
                'Repeat end date/time must be after or equal to start date/time'
                in ex.message)
        # All-day generator must have a start datetime with 00:00:00 time
        try:
            models.EventRepeatsGenerator(
            is_all_day=True,
                start=self.start.replace(hour=0, minute=0, second=1),
                end=self.start.replace(hour=0, minute=0, second=1),
            ).save()
            self.fail("Expected GeneratorException")
        except models.GeneratorException, ex:
            self.assertTrue(
                'Start date/time must be at 00:00:00 hours/minutes/seconds'
                ' for all-day generators'
                in ex.message)
        # All-day generator must have a duration that's a multiple of whole days
        models.EventRepeatsGenerator(
            is_all_day=True,
            start=self.start,
            end=self.start + timedelta(hours=24),
            event=G(models.Event),
        ).save()
        try:
            models.EventRepeatsGenerator(
                is_all_day=True,
                start=self.start,
                end=self.start + timedelta(hours=24, seconds=1),
            ).save()
            self.fail("Expected GeneratorException")
        except models.GeneratorException, ex:
            self.assertTrue(
                'Duration between start and end times must be multiples of'
                ' a day for all-day generators'
                in ex.message)

    def test_duration(self):
        self.assertEquals(
            timedelta(minutes=73),
            G(
                models.EventRepeatsGenerator,
                start=self.start,
                end=self.start + timedelta(minutes=73),
                event=G(models.Event),
            ).duration
        )
        self.assertEquals(
            timedelta(),
            G(
                models.EventRepeatsGenerator,
                start=self.start,
                end=self.start,
                event=G(models.Event),
            ).duration
        )
        self.assertEquals(
            timedelta(),
            G(
                models.EventRepeatsGenerator,
                is_all_day=True,
                start=self.start,
                end=self.start,
                event=G(models.Event),
            ).duration
        )

    def test_period(self):
        now = timezone.localize(timezone.now())
        self.assertIsNone(
            G(
                models.EventRepeatsGenerator,
                is_all_day=True,
                start=self.start,
                end=self.start,
                event=G(models.Event),
            ).period
        )
        self.assertEquals(
            'AM',
            G(
                models.EventRepeatsGenerator,
                start=now.replace(hour=0),
                end=now.replace(hour=0) + timedelta(hours=1),
                event=G(models.Event),
            ).period
        )
        self.assertEquals(
            'AM',
            G(
                models.EventRepeatsGenerator,
                start=now.replace(hour=11),
                end=now.replace(hour=11) + timedelta(hours=1),
                event=G(models.Event),
            ).period
        )
        self.assertEquals(
            'PM',
            G(
                models.EventRepeatsGenerator,
                start=now.replace(hour=12),
                end=now.replace(hour=12) + timedelta(hours=1),
                event=G(models.Event),
            ).period
        )
        self.assertEquals(
            'PM',
            G(
                models.EventRepeatsGenerator,
                start=now.replace(hour=23),
                end=now.replace(hour=23) + timedelta(hours=1),
                event=G(models.Event),
            ).period
        )

    def test_limited_daily_repeating_generator(self):
        generator = G(
            models.EventRepeatsGenerator,
            start=self.start,
            end=self.end,
            recurrence_rule='FREQ=DAILY',
            repeat_end=self.start + timedelta(days=20),  # Exclusive end time
        )
        # Repeating generator has expected date entries in its RRULESET
        rruleset = generator.get_rruleset()
        self.assertEqual(20, rruleset.count())
        self.assertTrue(self.start in rruleset)
        self.assertTrue(self.start + timedelta(days=1) in rruleset)
        self.assertTrue(self.start + timedelta(days=2) in rruleset)
        self.assertTrue(self.start + timedelta(days=19) in rruleset)
        self.assertFalse(self.start + timedelta(days=20) in rruleset)
        # Repeating generator generates expected start/end times
        start_and_end_times_list = list(generator.generate())
        self.assertEqual(20, len(start_and_end_times_list))
        self.assertEqual(
            (self.start, self.end),
            start_and_end_times_list[0])
        self.assertEqual(
            (self.start + timedelta(days=1), self.end + timedelta(days=1)),
            start_and_end_times_list[1])
        self.assertEqual(
            (self.start + timedelta(days=2), self.end + timedelta(days=2)),
            start_and_end_times_list[2])
        self.assertEqual(
            (self.start + timedelta(days=19), self.end + timedelta(days=19)),
            start_and_end_times_list[19])
        self.assertFalse(
            (self.start + timedelta(days=20), self.end + timedelta(days=20))
            in start_and_end_times_list)

    def test_unlimited_daily_repeating_generator(self):
        generator = G(
            models.EventRepeatsGenerator,
            start=self.start,
            end=self.end,
            recurrence_rule='FREQ=DAILY',
        )
        # Repeating generator has expected date entries in its RRULESET
        rruleset = generator.get_rruleset()
        self.assertTrue(self.start in rruleset)
        self.assertTrue(self.start + timedelta(days=1) in rruleset)
        self.assertTrue(self.start + timedelta(days=2) in rruleset)
        # Default ``appsettings.REPEAT_LIMIT`` is 13 weeks
        self.assertTrue(self.start + timedelta(days=7 * 13) in rruleset)
        self.assertFalse(self.start + timedelta(days=7 * 13 + 1) in rruleset)
        # Repeating generator generates expected start/end times
        start_and_end_times = generator.generate()
        self.assertEqual(
            (self.start, self.end),
            start_and_end_times.next())
        self.assertEqual(
            (self.start + timedelta(days=1), self.end + timedelta(days=1)),
            start_and_end_times.next())
        self.assertEqual(
            (self.start + timedelta(days=2), self.end + timedelta(days=2)),
            start_and_end_times.next())
        for i in range(16):
            start_and_end_times.next()
        self.assertEqual(
            (self.start + timedelta(days=19), self.end + timedelta(days=19)),
            start_and_end_times.next())
        # Default ``appsettings.REPEAT_LIMIT`` is 13 weeks
        for i in range(13 * 7 - 20):
            start_and_end_times.next()
        self.assertEqual(
            (self.start + timedelta(days=91), self.end + timedelta(days=91)),
            start_and_end_times.next())


class TestEventOccurrences(TestCase):

    def setUp(self):
        """
        Create an event with a daily repeat generator.
        """
        self.start = time.round_datetime(
            when=timezone.now(),
            precision=timedelta(days=1),
            rounding=time.ROUND_DOWN)
        self.end = self.start + appsettings.DEFAULT_ENDS_DELTA

    def test_initial_event_occurrences_automatically_created(self):
        event = G(models.Event)
        self.assertEqual(event.occurrences.count(), 0)
        # Occurrences generated for event when `EventRepeatsGenerator` added
        G(
            models.EventRepeatsGenerator,
            event=event,
            start=self.start,
            end=self.end,
            recurrence_rule='FREQ=DAILY',
            repeat_end=self.start + timedelta(days=20),  # Exclusive end time
        )
        self.assertEqual(event.occurrences.count(), 20)
        # An occurrence exists for each expected start time
        occurrence_starts = get_occurrences_start_datetimes_for_event(event)
        first_occurrence_start = event.occurrences.all()[0].start
        for days_hence in range(20):
            start = first_occurrence_start + timedelta(days=days_hence)
            self.assertTrue(start in occurrence_starts,
                            "Missing start time %d days hence" % days_hence)

    def test_limited_daily_repeating_occurrences(self):
        event = G(models.Event)
        G(
            models.EventRepeatsGenerator,
            event=event,
            start=self.start,
            end=self.end,
            recurrence_rule='FREQ=DAILY',
            repeat_end=self.start + timedelta(days=20),  # Exclusive end time
        )
        self.assertEqual(20, event.occurrences.all().count())
        self.assertEqual(
            self.start,
            event.occurrences.all()[0].start)
        self.assertEqual(
            self.start + timedelta(days=1),
            event.occurrences.all()[1].start)
        self.assertEqual(
            self.start + timedelta(days=2),
            event.occurrences.all()[2].start)
        self.assertEqual(
            self.start + timedelta(days=19),
            event.occurrences.all()[19].start)

    def test_unlimited_daily_repeating_occurrences(self):
        event = G(models.Event)
        G(
            models.EventRepeatsGenerator,
            event=event,
            start=self.start,
            end=self.end,
            recurrence_rule='FREQ=DAILY',
        )
        # Default ``appsettings.REPEAT_LIMIT`` is 13 weeks
        self.assertEqual(7 * 13 + 1, event.occurrences.all().count())
        self.assertEqual(
            self.start,
            event.occurrences.all()[0].start)
        self.assertEqual(
            self.start + timedelta(days=1),
            event.occurrences.all()[1].start)
        self.assertEqual(
            self.start + timedelta(days=2),
            event.occurrences.all()[2].start)
        self.assertEqual(
            self.start + timedelta(days=19),
            event.occurrences.all()[19].start)
        # Default repeat limit prevents far-future occurrences but we can
        # override that if we want
        event.extend_occurrences(until=self.end + timedelta(days=999))
        self.assertEqual(1000, event.occurrences.all().count())
        self.assertEqual(
            self.start + timedelta(days=999),
            event.occurrences.all()[999].start)

    def test_add_arbitrary_occurrence_to_nonrepeating_event(self):
        event = G(models.Event)
        self.assertEqual(0, event.occurrences.count())
        # Add an arbitrary occurrence
        arbitrary_dt1 = self.start + timedelta(days=3, hours=-2)
        added_occurrence = event.add_occurrence(arbitrary_dt1)
        # Confirm arbitrary occurrence is associated with event
        self.assertEqual(1, event.occurrences.count())
        # Confirm arbitrary occurrence has expected values
        self.assertEqual(added_occurrence, event.occurrences.all()[0])
        self.assertEqual(arbitrary_dt1, added_occurrence.start)
        self.assertEqual(
            arbitrary_dt1, added_occurrence.end)
        self.assertEqual(timedelta(), added_occurrence.duration)
        self.assertFalse(added_occurrence.is_generated)
        self.assertTrue(added_occurrence.is_user_modified)

    def test_add_arbitrary_occurrences_to_repeating_event(self):
        arbitrary_dt1 = self.start + timedelta(days=3, hours=-2)
        arbitrary_dt2 = self.start + timedelta(days=7, hours=5)
        event = G(models.Event)
        generator = G(
            models.EventRepeatsGenerator,
            event=event,
            start=self.start,
            end=self.end,
            recurrence_rule='FREQ=WEEKLY',
            repeat_end=self.start + timedelta(days=7 * 4),
        )
        self.assertEqual(4, event.occurrences.count())
        self.assertEqual(self.start, event.occurrences.all()[0].start)
        self.assertEqual(self.end, event.occurrences.all()[0].end)
        rruleset = generator.get_rruleset()
        self.assertEqual(4, rruleset.count())
        self.assertFalse(arbitrary_dt1 in rruleset)
        self.assertFalse(arbitrary_dt2 in rruleset)
        # Add arbitrary occurrences
        added_occurrence_1 = event.add_occurrence(arbitrary_dt1)
        added_occurrence_2 = event.add_occurrence(
            arbitrary_dt2,
            # NOTE: Custom end time, so duration will differ from Event's
            end=arbitrary_dt2 + timedelta(minutes=1))
        # Confirm arbitrary occurrences are associated with event
        self.assertEqual(6, event.occurrences.count())
        self.assertEqual(2, event.occurrences.filter(is_user_modified=True).count())
        # Confirm arbitrary occurrences have expected values
        self.assertEqual(added_occurrence_1, event.occurrences.all()[1])
        self.assertEqual(arbitrary_dt1, added_occurrence_1.start)
        self.assertEqual(
            arbitrary_dt1, added_occurrence_1.end)
        self.assertEqual(timedelta(), added_occurrence_1.duration)
        self.assertFalse(added_occurrence_1.is_generated)
        self.assertTrue(added_occurrence_1.is_user_modified)

        self.assertEqual(added_occurrence_2, event.occurrences.all()[3])
        self.assertEqual(arbitrary_dt2, added_occurrence_2.start)
        self.assertEqual(
            arbitrary_dt2 + timedelta(minutes=1), added_occurrence_2.end)
        self.assertEqual(timedelta(minutes=1), added_occurrence_2.duration)
        self.assertFalse(added_occurrence_2.is_generated)
        self.assertTrue(added_occurrence_2.is_user_modified)
        # Check regenerating occurrences leaves added ones in place...
        event.regenerate_occurrences()
        self.assertTrue(added_occurrence_1 in event.occurrences.all())
        self.assertTrue(added_occurrence_2 in event.occurrences.all())

    def test_cancel_arbitrary_occurrence_from_repeating_event(self):
        event = G(models.Event)
        G(
            models.EventRepeatsGenerator,
            event=event,
            start=self.start,
            end=self.end,
            recurrence_rule='FREQ=WEEKLY',
            repeat_end=self.start + timedelta(days=7 * 8),
        )
        self.assertEqual(8, event.occurrences.count())
        # Find valid occurrences to cancel
        occurrence_to_cancel_1 = event.occurrences.all()[3]
        occurrence_to_cancel_2 = event.occurrences.all()[5]
        occurrence_starts = get_occurrences_start_datetimes_for_event(event)
        self.assertTrue(occurrence_to_cancel_1.start in occurrence_starts)
        self.assertTrue(occurrence_to_cancel_2.start in occurrence_starts)
        # Cancel occurrences
        event.cancel_occurrence(occurrence_to_cancel_1)
        event.cancel_occurrence(
            occurrence_to_cancel_2, reason='Just because...',
            hide_cancelled_occurrence=True)
        # Check field values change as expected when an occurrence is deleted
        occurrence_to_cancel_1 = models.Occurrence.objects.get(pk=occurrence_to_cancel_1.pk)
        self.assertTrue(occurrence_to_cancel_1.is_user_modified)
        self.assertTrue(occurrence_to_cancel_1.is_cancelled)
        self.assertFalse(occurrence_to_cancel_1.is_hidden)
        self.assertEqual('Cancelled', occurrence_to_cancel_1.cancel_reason)
        occurrence_to_cancel_2 = models.Occurrence.objects.get(pk=occurrence_to_cancel_2.pk)
        self.assertTrue(occurrence_to_cancel_2.is_user_modified)
        self.assertTrue(occurrence_to_cancel_2.is_cancelled)
        self.assertTrue(occurrence_to_cancel_2.is_hidden)
        self.assertEqual('Just because...', occurrence_to_cancel_2.cancel_reason)
        # Confirm cancelled occurrences remain in Event's occurrences set
        self.assertEqual(8, event.occurrences.count())
        self.assertTrue(occurrence_to_cancel_1 in event.occurrences.all())
        self.assertTrue(occurrence_to_cancel_2 in event.occurrences.all())
        # Confirm we can easily filter out deleted occurrences
        self.assertEqual(6, event.occurrences.exclude(is_cancelled=True).count())
        self.assertFalse(occurrence_to_cancel_1 in event.occurrences.exclude(is_cancelled=True))
        self.assertFalse(occurrence_to_cancel_2 in event.occurrences.exclude(is_cancelled=True))
        # Check regenerating occurrences leaves cancelled ones in place...
        event.regenerate_occurrences()
        self.assertTrue(occurrence_to_cancel_1 in event.occurrences.all())
        self.assertTrue(occurrence_to_cancel_2 in event.occurrences.all())
        # ...and does not generate new occurrences in cancelled timeslots
        self.assertEqual(6, event.occurrences.exclude(is_cancelled=True).count())
        # Removing invalid occurrences has no effect
        some_other_event = G(
            models.Event,
            start=self.start,
            end=self.end,
        )
        invalid_occurrence = models.Occurrence.objects.create(
            event=some_other_event,
            start=self.start + timedelta(minutes=25),
            end=self.end + timedelta(minutes=25),
        )
        event.cancel_occurrence(invalid_occurrence)
        self.assertEqual(8, event.occurrences.count())

    def test_create_missing_event_occurrences(self):
        event = G(models.Event)
        G(
            models.EventRepeatsGenerator,
            event=event,
            start=self.start,
            end=self.end,
            recurrence_rule='FREQ=DAILY',
            repeat_end=self.start + timedelta(days=20),  # Exclusive end time
        )
        self.assertEqual(len(list(event.missing_occurrence_data())), 0)
        # Delete a few occurrences to simulate "missing" ones
        event.occurrences.filter(
            start__gte=event.occurrences.all()[5].start).delete()
        self.assertEqual(len(list(event.missing_occurrence_data())), 15)
        call_command('create_event_occurrences')
        self.assertEqual(len(list(event.missing_occurrence_data())), 0)
        self.assertEqual(event.occurrences.count(), 20)
        self.assertEqual(models.Event.objects.count(), 1)

    # TODO test_add_eventrepeatsrule

    # TODO test_remove_eventrepeatsrule

    # TODO test_change_eventrepeatsrule


class Views(WebTest):

    def test_index(self):
        response = self.app.get(reverse('icekit_events_index'))
        response.mustcontain('There are no events.')


class Time(TestCase):

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
