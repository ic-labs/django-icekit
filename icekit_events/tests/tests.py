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


class Forms(WebTest):
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


class Migrations(WebTest):
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

    def test_Occurrence_str(self):
        event = G(models.Event, title="Event title")
        occurrence = models.Occurrence(event=event)
        self.assertTrue('"Event title"' in six.text_type(occurrence))

    def test_Event_clean(self):
        """
        Test model validation.
        """
        now = timezone.now()
        date_now = now.date()
        recurrence_rule = 'FREQ=DAILY'

        # Do not unset `end_repeat` when a recurrence rule is set.
        event = G(
            models.Event,
            recurrence_rule=recurrence_rule,
            starts=now,
            end_repeat=now)
        event.full_clean()
        self.assertEqual(event.end_repeat, now)

        # Unset `end_repeat` if no recurrence rule is set.
        event.recurrence_rule = None
        event.full_clean()
        self.assertEqual(event.end_repeat, None)

        # Do not unset `date_end_repeat` when a recurrence rule is set.
        event = G(
            models.Event,
            all_day=True,
            recurrence_rule=recurrence_rule,
            date_starts=date_now,
            date_end_repeat=date_now)
        event.full_clean()
        self.assertEqual(event.date_end_repeat, now.date())

        # Unset `end_repeat` if no recurrence rule is set.
        event.recurrence_rule = None
        event.full_clean()
        self.assertEqual(event.date_end_repeat, None)

        # Check validation if an all day event does not have a start date
        event = N(
            models.Event,
            all_day=True,
            recurrence_rule=recurrence_rule,
            date_starts=None,
            date_end_repeat=date_now)

        with self.assertRaises(ValidationError) as cm:
            event.full_clean()

        self.assertIn('date_starts', cm.exception.error_dict.keys())

        event.all_day = False
        event.starts = None

        with self.assertRaises(ValidationError) as cm:
            event.full_clean()

        self.assertIn('starts', cm.exception.error_dict.keys())

    def test_Event_change_detection(self):
        """
        Test that changes to event repeat fields are detected.
        """
        # Create an event.
        event = G(
            models.Event,
            starts=timezone.now()
        )
        self.assertFalse(event._monitor_fields_changed())
        # Save an unchanged event
        event.save()
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

    def test_Event_parent(self):
        now = timezone.now()

        # Original is originating event for itself.
        event = G(
            models.Event,
            starts=now,
            ends=now,
            recurrence_rule='FREQ=DAILY')
        self.assertIsNone(event.parent)
        # Variation is originating event for itself.
        variation = event.make_variation(
            event.get_future_occurrences()[5])
        variation.title = 'Variation'
        variation.save()
        self.assertNotEqual(event.pk, variation.pk)
        self.assertEqual(event, variation.parent)

    def test_Event_str(self):
        event = G(
            models.Event,
            title='title',
            starts=timezone.now()
        )
        self.assertEqual(six.text_type(event), 'title')

    def test_Event_period(self):
        now = timezone.localize(timezone.now())
        event = G(models.Event, starts=now.replace(hour=0))
        self.assertEqual("AM", event.period)
        event = G(models.Event, starts=now.replace(hour=11))
        self.assertEqual("AM", event.period)
        event = G(models.Event, starts=now.replace(hour=12))
        self.assertEqual("PM", event.period)

    def test_RecurrenceRule_str(self):
        recurrence_rule = G(
            models.RecurrenceRule,
            description='description',
            recurrence_Rule='FREQ=DAILY',
        )
        self.assertEqual(six.text_type(recurrence_rule), 'description')


class TestEventRRulesAndOccurrences(WebTest):

    def setUp(self):
        """ Create a daily recurring event with no end date """
        self.starts = time.round_datetime(
            when=timezone.now(),
            precision=timedelta(days=1),
            rounding=time.ROUND_DOWN)
        self.ends = self.starts + appsettings.DEFAULT_ENDS_DELTA

    def test_non_repeating_event(self):
        event = G(
            models.Event,
            starts=self.starts,
            ends=self.ends,
        )
        # Non-repeating event has a single date entry in its RRULESET
        self.assertEqual(1, event.get_rruleset().count())
        self.assertTrue(self.starts in event.get_rruleset())
        # Occurrences match RRULESET
        self.assertEqual(1, event.occurrences.all().count())
        self.assertTrue(event.occurrences.all()[0].starts == self.starts)
        self.assertTrue(self.starts in get_occurrences_start_datetimes_for_event(event))

    def test_limited_repeating_event(self):
        event = G(
            models.Event,
            starts=self.starts,
            ends=self.ends,
            recurrence_rule='FREQ=DAILY',
            end_repeat=self.starts + timedelta(days=20),  # Exclusive end time
        )
        # Repeating event has 20 date entries in its RRULESET
        rruleset = event.get_rruleset()
        self.assertEqual(20, rruleset.count())
        self.assertTrue(self.starts in rruleset)
        self.assertTrue(self.starts + timedelta(days=1) in rruleset)
        self.assertTrue(self.starts + timedelta(days=2) in rruleset)
        self.assertTrue(self.starts + timedelta(days=19) in rruleset)
        self.assertFalse(self.starts + timedelta(days=20) in rruleset)
        # Occurrences match RRULESET
        occurrence_starts = get_occurrences_start_datetimes_for_event(event)
        self.assertEqual(20, event.occurrences.all().count())
        self.assertTrue(self.starts in occurrence_starts)
        self.assertTrue(self.starts + timedelta(days=1) in occurrence_starts)
        self.assertTrue(self.starts + timedelta(days=2) in occurrence_starts)
        self.assertTrue(self.starts + timedelta(days=19) in occurrence_starts)
        self.assertFalse(self.starts + timedelta(days=20) in occurrence_starts)

    def test_unlimited_repeating_event(self):
        event = G(
            models.Event,
            starts=self.starts,
            ends=self.ends,
            recurrence_rule='FREQ=DAILY',
        )
        # Repeating event has expected date entries in its RRULESET
        rruleset = event.get_rruleset()
        self.assertTrue(self.starts in rruleset)
        self.assertTrue(self.starts + timedelta(days=1) in rruleset)
        self.assertTrue(self.starts + timedelta(days=2) in rruleset)
        self.assertTrue(self.starts + timedelta(days=999) in rruleset)
        # Occurrences match RRULESET
        occurrence_starts = get_occurrences_start_datetimes_for_event(event)
        self.assertTrue(self.starts in occurrence_starts)
        self.assertTrue(self.starts + timedelta(days=1) in occurrence_starts)
        self.assertTrue(self.starts + timedelta(days=2) in occurrence_starts)
        # Default repeat limit prevents far-future occurrences...
        self.assertFalse(self.starts + timedelta(days=999) in occurrence_starts)
        # ... but we can override that if necessary
        event.extend_occurrences(until=self.ends + timedelta(days=999))
        self.assertEqual(1000, event.occurrences.all().count())
        occurrence_starts = get_occurrences_start_datetimes_for_event(event)
        self.assertTrue(self.starts + timedelta(days=999) in occurrence_starts)

    #def test_limited_repeating_event_with_variations(self):
    #    event = G(
    #        models.Event,
    #        starts=self.starts,
    #        ends=self.ends,
    #        recurrence_rule='FREQ=DAILY',
    #        end_repeat=self.starts + timedelta(days=20),  # Exclusive end time
    #    )
    #    rruleset = event.get_rruleset()
    #    self.assertEqual(20, rruleset.count())
    #    self.assertTrue(self.starts in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=1) in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=2) in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=5) in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=7) in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=8) in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=11) in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=12) in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=13) in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=14) in rruleset)
    #    # One-time variation: 2 days from start
    #    variation1 = G(
    #        models.Event,
    #        parent=event,
    #        starts=self.starts + timedelta(days=2),
    #        ends=self.ends + timedelta(days=2),
    #    )
    #    rruleset = event.get_rruleset()
    #    self.assertEqual(19, rruleset.count())
    #    self.assertFalse(self.starts + timedelta(days=2) in rruleset)
    #    # One-time variation: 5 days from start with different start/end times
    #    variation2 = G(
    #        models.Event,
    #        parent=event,
    #        starts=self.starts + timedelta(days=5, hours=-3),
    #        ends=self.ends + timedelta(days=5, hours=-2),
    #    )
    #    self.assertEqual(1, variation2.get_rruleset().count())
    #    rruleset = event.get_rruleset()
    #    self.assertEqual(18, rruleset.count())
    #    self.assertFalse(self.starts + timedelta(days=5) in rruleset)
    #    # Repeating variation: 7 days from start lasting 2 days
    #    variation3 = G(
    #        models.Event,
    #        parent=event,
    #        starts=self.starts + timedelta(days=7),
    #        ends=self.ends + timedelta(days=7),
    #        recurrence_rule='FREQ=DAILY',
    #        end_repeat=self.ends + timedelta(days=8),  # Exclusive end time
    #    )
    #    self.assertEqual(2, variation3.get_rruleset().count())
    #    rruleset = event.get_rruleset()
    #    self.assertEqual(16, rruleset.count())
    #    self.assertFalse(self.starts + timedelta(days=7) in rruleset)
    #    self.assertFalse(self.starts + timedelta(days=8) in rruleset)
    #    # Repeating variation: 11 days from start lasting 4 days with different
    #    # start/end times
    #    variation4 = G(
    #        models.Event,
    #        parent=event,
    #        starts=self.starts + timedelta(days=11, hours=3),
    #        ends=self.ends + timedelta(days=11, hours=3, minutes=30),
    #        recurrence_rule='FREQ=DAILY',
    #        end_repeat=self.starts + timedelta(days=14, hours=3, minutes=1),  # Exclusive end time
    #    )
    #    self.assertEqual(4, variation4.get_rruleset().count())
    #    # Repeating event excludes variation periods from its RRULESET
    #    rruleset = event.get_rruleset()
    #    self.assertEqual(12, rruleset.count())
    #    self.assertTrue(self.starts in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=10) in rruleset)
    #    self.assertFalse(self.starts + timedelta(days=11) in rruleset)
    #    self.assertFalse(self.starts + timedelta(days=12) in rruleset)
    #    self.assertFalse(self.starts + timedelta(days=13) in rruleset)
    #    self.assertFalse(self.starts + timedelta(days=14) in rruleset)
    #    self.assertTrue(self.starts + timedelta(days=15) in rruleset)
    #    # Occurrences match RRULESET
    #    occurrence_starts = get_occurrences_start_datetimes_for_event(event)
    #    self.assertEqual(12, event.occurrences.all().count())
    #    self.assertTrue(self.starts in occurrence_starts)
    #    self.assertTrue(self.starts + timedelta(days=10) in occurrence_starts)
    #    self.assertFalse(self.starts + timedelta(days=11) in occurrence_starts)
    #    self.assertFalse(self.starts + timedelta(days=12) in occurrence_starts)
    #    self.assertFalse(self.starts + timedelta(days=13) in occurrence_starts)
    #    self.assertFalse(self.starts + timedelta(days=14) in occurrence_starts)
    #    self.assertTrue(self.starts + timedelta(days=15) in occurrence_starts)

    def test_unlimited_repeating_event_with_variations(self):
        event = G(
            models.Event,
            starts=self.starts,
            ends=self.ends,
            recurrence_rule='FREQ=DAILY',
        )
        # Repeating event has expected date entries in its RRULESET
        rruleset = event.get_rruleset()
        self.assertTrue(self.starts in rruleset)
        self.assertTrue(self.starts + timedelta(days=1) in rruleset)
        self.assertTrue(self.starts + timedelta(days=2) in rruleset)
        self.assertTrue(self.starts + timedelta(days=100) in rruleset)
        self.assertTrue(self.starts + timedelta(days=101) in rruleset)
        self.assertTrue(self.starts + timedelta(days=102) in rruleset)
        self.assertTrue(self.starts + timedelta(days=103) in rruleset)
        self.assertTrue(self.starts + timedelta(days=104) in rruleset)
        self.assertTrue(self.starts + timedelta(days=105) in rruleset)
        self.assertTrue(self.starts + timedelta(days=106) in rruleset)
        self.assertTrue(self.starts + timedelta(days=107) in rruleset)
        self.assertTrue(self.starts + timedelta(days=108) in rruleset)
        self.assertTrue(self.starts + timedelta(days=200) in rruleset)
        self.assertTrue(self.starts + timedelta(days=300) in rruleset)
        self.assertTrue(self.starts + timedelta(days=1000) in rruleset)
        # Repeating variation: 100 days from start with two occurrences a
        # week apart with different start/end times
        variation = G(
            models.Event,
            parent=event,
            starts=self.starts + timedelta(days=100, hours=-3),
            ends=self.ends + timedelta(days=100, hours=-3, minutes=-30),
            recurrence_rule='FREQ=WEEKLY',
            end_repeat=self.ends + timedelta(days=107),
        )
        v_rruleset = variation.get_rruleset()
        self.assertEqual(2, v_rruleset.count())
        self.assertTrue(self.starts + timedelta(days=100, hours=-3) in v_rruleset)
        self.assertTrue(self.starts + timedelta(days=107, hours=-3) in v_rruleset)
        ## Repeating event excludes entire variation period from its RRULESET
        #rruleset = event.get_rruleset()
        #self.assertTrue(self.starts in rruleset)
        #self.assertTrue(self.starts + timedelta(days=99) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=100) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=101) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=102) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=103) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=104) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=105) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=106) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=107) in rruleset)
        #self.assertTrue(self.starts + timedelta(days=108) in rruleset)
        ## Repeating variation: 200 days from start with unlimited occurrences a
        ## week apart with different start/end times
        #variation2 = G(
        #    models.Event,
        #    parent=event,
        #    starts=self.starts + timedelta(days=200, hours=3),
        #    ends=self.ends + timedelta(days=200, hours=3, minutes=-30),
        #    recurrence_rule='FREQ=WEEKLY',
        #)
        #v2rruleset = variation2.get_rruleset()
        #self.assertTrue(self.starts + timedelta(days=200, hours=3) in v2rruleset)
        #self.assertTrue(self.starts + timedelta(days=207, hours=3) in v2rruleset)
        #self.assertTrue(self.starts + timedelta(days=298, hours=3) in v2rruleset)
        ## NOTE: In theory, updating the parent event's `end_repeat` shouldn't
        ## be necessary since the unlimited exclusion rrule will cancel out the
        ## unlimited original event occurrences. But the rruleset performance
        ## is terrible in this situation, so it needs the extra help.
        #event.end_repeat = variation2.starts
        #event.save()
        ## Repeating event excludes entire variation period from its RRULESET
        #rruleset = event.get_rruleset()
        #self.assertEqual(192, rruleset.count())
        #self.assertTrue(self.starts in rruleset)
        #self.assertTrue(self.starts + timedelta(days=199) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=200) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=201) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=202) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=203) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=204) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=205) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=206) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=207) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=300) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=1000) in rruleset)
        ## Occurrences match RRULESET
        #event.extend_occurrences(event.ends + timedelta(days=300))
        #self.assertEqual(192, event.occurrences.count())
        #occurrence_starts = get_occurrences_start_datetimes_for_event(event)
        #self.assertTrue(self.starts in occurrence_starts)
        #self.assertTrue(self.starts + timedelta(days=99) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=100) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=101) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=102) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=103) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=104) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=105) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=106) in rruleset)
        #self.assertFalse(self.starts + timedelta(days=107) in rruleset)
        #self.assertTrue(self.starts + timedelta(days=108) in rruleset)
        #self.assertTrue(self.starts + timedelta(days=199) in occurrence_starts)
        #self.assertFalse(self.starts + timedelta(days=200) in occurrence_starts)
        #self.assertFalse(self.starts + timedelta(days=201) in occurrence_starts)
        #self.assertFalse(self.starts + timedelta(days=300) in occurrence_starts)

    def test_add_arbitrary_occurrence_to_nonrepeating_event(self):
        event = G(
            models.Event,
            starts=self.starts,
            ends=self.ends,
        )
        self.assertEqual(1, event.occurrences.count())
        self.assertEqual(event.starts, event.occurrences.all()[0].starts)
        self.assertEqual(event.ends, event.occurrences.all()[0].ends)
        rruleset = event.get_rruleset()
        self.assertEqual(1, rruleset.count())
        # Add an arbitrary occurrence
        arbitrary_dt1 = event.starts + timedelta(days=3, hours=-2)
        added_occurrence = event.add_occurrence(arbitrary_dt1)
        # Confirm arbitrary occurrence is associated with event
        self.assertEqual(2, event.occurrences.count())
        # Confirm arbitrary occurrence has expected values
        self.assertEqual(added_occurrence, event.occurrences.all()[1])
        self.assertEqual(arbitrary_dt1, added_occurrence.starts)
        self.assertEqual(
            arbitrary_dt1 + event.duration, added_occurrence.ends)
        self.assertEqual(event.duration, added_occurrence.duration)
        self.assertFalse(added_occurrence.is_generated)
        self.assertTrue(added_occurrence.is_user_modified)

    def test_add_arbitrary_occurrences_to_repeating_event(self):
        arbitrary_dt1 = self.starts + timedelta(days=3, hours=-2)
        arbitrary_dt2 = self.starts + timedelta(days=7, hours=5)
        event = G(
            models.Event,
            starts=self.starts,
            ends=self.ends,
            recurrence_rule='FREQ=WEEKLY',
            end_repeat=self.starts + timedelta(days=7 * 4),
        )
        self.assertEqual(4, event.occurrences.count())
        self.assertEqual(event.starts, event.occurrences.all()[0].starts)
        self.assertEqual(event.ends, event.occurrences.all()[0].ends)
        rruleset = event.get_rruleset()
        self.assertEqual(4, rruleset.count())
        self.assertFalse(arbitrary_dt1 in rruleset)
        self.assertFalse(arbitrary_dt2 in rruleset)
        # Add arbitrary occurrences
        added_occurrence_1 = event.add_occurrence(arbitrary_dt1)
        added_occurrence_2 = event.add_occurrence(
            arbitrary_dt2,
            # NOTE: Custom end time, so duration will differ from Event's
            ends=arbitrary_dt2 + timedelta(minutes=1))
        # Confirm arbitrary occurrences are associated with event
        self.assertEqual(6, event.occurrences.count())
        # Confirm arbitrary occurrences have expected values
        self.assertEqual(added_occurrence_1, event.occurrences.all()[1])
        self.assertEqual(arbitrary_dt1, added_occurrence_1.starts)
        self.assertEqual(
            arbitrary_dt1 + event.duration, added_occurrence_1.ends)
        self.assertEqual(self.ends - self.starts, added_occurrence_1.duration)
        self.assertFalse(added_occurrence_1.is_generated)
        self.assertTrue(added_occurrence_1.is_user_modified)

        self.assertEqual(added_occurrence_2, event.occurrences.all()[3])
        self.assertEqual(arbitrary_dt2, added_occurrence_2.starts)
        self.assertEqual(
            arbitrary_dt2 + timedelta(minutes=1), added_occurrence_2.ends)
        self.assertEqual(timedelta(minutes=1), added_occurrence_2.duration)
        self.assertFalse(added_occurrence_2.is_generated)
        self.assertTrue(added_occurrence_2.is_user_modified)

    def test_cancel_arbitrary_occurrence_from_repeating_event(self):
        event = G(
            models.Event,
            starts=self.starts,
            ends=self.ends,
            recurrence_rule='FREQ=WEEKLY',
            end_repeat=self.starts + timedelta(days=7 * 8),
        )
        self.assertEqual(8, event.occurrences.count())
        # Find valid occurrences to remove
        occurrence_to_cancel_1 = event.occurrences.all()[3]
        occurrence_to_cancel_2 = event.occurrences.all()[5]
        occurrence_starts = get_occurrences_start_datetimes_for_event(event)
        self.assertTrue(occurrence_to_cancel_1.starts in occurrence_starts)
        self.assertTrue(occurrence_to_cancel_2.starts in occurrence_starts)
        # Cancel occurrences
        event.delete_occurrence(occurrence_to_cancel_1)
        event.delete_occurrence(
            occurrence_to_cancel_2, reason='Just because...',
            hide_deleted_occurrence=True)
        # Check field values change as expected when an occurrence is deleted
        occurrence_to_cancel_1 = models.Occurrence.objects.get(pk=occurrence_to_cancel_1.pk)
        self.assertTrue(occurrence_to_cancel_1.is_user_modified)
        self.assertTrue(occurrence_to_cancel_1.is_deleted)
        self.assertFalse(occurrence_to_cancel_1.is_hidden)
        self.assertEqual('Cancelled', occurrence_to_cancel_1.deleted_reason)
        occurrence_to_cancel_2 = models.Occurrence.objects.get(pk=occurrence_to_cancel_2.pk)
        self.assertTrue(occurrence_to_cancel_2.is_user_modified)
        self.assertTrue(occurrence_to_cancel_2.is_deleted)
        self.assertTrue(occurrence_to_cancel_2.is_hidden)
        self.assertEqual('Just because...', occurrence_to_cancel_2.deleted_reason)
        # Confirm "deleted" occurrences remain in Event's occurrences set
        self.assertEqual(8, event.occurrences.count())
        self.assertTrue(occurrence_to_cancel_1 in event.occurrences.all())
        self.assertTrue(occurrence_to_cancel_2 in event.occurrences.all())
        # Confirm we can easily filter out deleted occurrences
        self.assertEqual(6, event.occurrences.exclude(is_deleted=True).count())
        self.assertFalse(occurrence_to_cancel_1 in event.occurrences.exclude(is_deleted=True))
        self.assertFalse(occurrence_to_cancel_2 in event.occurrences.exclude(is_deleted=True))
        # Removing invalid occurrences has no effect
        some_other_event = G(
            models.Event,
            starts=self.starts,
            ends=self.ends,
        )
        invalid_occurrence = models.Occurrence.objects.create(
            event=some_other_event,
            starts=event.starts + timedelta(minutes=25),
            ends=event.ends + timedelta(minutes=25),
        )
        event.delete_occurrence(invalid_occurrence)
        self.assertEqual(8, event.occurrences.count())


class TestRecurringEvents(WebTest):

    def setUp(self):
        """
        Create an event with a daily recurrence rule.
        """
        starts = time.round_datetime(
            when=timezone.now(),
            precision=timedelta(days=1),
            rounding=time.ROUND_DOWN)
        ends = starts + appsettings.DEFAULT_ENDS_DELTA
        # The `end_repeat` is exclusive and will not be included as an
        # occurrence, so adding 20 days to `starts` will give us 20 occurrences
        # in total. The root event plus 19 repeat events.
        end_repeat = starts + timedelta(days=20)

        # Repeat events are created automatically for new events.
        self.event = G(
            models.Event,
            title='event',
            starts=starts,
            ends=ends,
            recurrence_rule='FREQ=DAILY',
            end_repeat=end_repeat,
        )

    def test_create_event_occurrences(self):
        # Occurrences are created automatically for new events.
        self.assertEqual(self.event.occurrences.count(), 20)
        # First occurrence is the same as the event start time
        first_occurrence = self.event.occurrences.all()[0]
        self.assertEqual(self.event.starts, first_occurrence.starts)
        self.assertEqual(self.event.ends, first_occurrence.ends)
        # An occurrence exists for each expected start time
        occurrence_starts = get_occurrences_start_datetimes_for_event(self.event)
        for days_hence in range(20):
            starts = self.event.starts + timedelta(days=days_hence)
            self.assertTrue(starts in occurrence_starts,
                            "Missing start time %d days hence" % days_hence)

    def test_get_future_occurrences(self):
        # `get_future_occurrences` queryset does not include the event's start
        self.assertEqual(self.event.get_future_occurrences().count(), 19)
        self.assertEqual(self.event.occurrences.count(), 20)
        self.assertEqual(self.event.occurrences.all()[1],
                         self.event.get_future_occurrences()[0])

    #def test_make_variation_single_day(self):
    #    variation_point = self.event.occurrences.all()[10]
    #    # Sanity-check our starting point
    #    self.assertEqual(20, self.event.occurrences.all().count())
    #    self.assertTrue(variation_point.starts
    #                    in get_occurrences_start_datetimes_for_event(self.event))
    #    # Create one-day variation by overriding parent's recurrence rule
    #    variation = self.event.make_variation(
    #        variation_point, recurrence_rule=None)
    #    # Confirm results
    #    self.assertEqual(1, variation.occurrences.all().count())
    #    self.assertTrue(variation_point.starts
    #                    in get_occurrences_start_datetimes_for_event(variation))
    #    self.assertEqual(19, self.event.occurrences.all().count())
    #    self.assertFalse(variation_point.starts
    #                     in get_occurrences_start_datetimes_for_event(self.event))

    def test_make_variation_that_splits_parent_series_to_end(self):
        # Create a variation event. Occurrences for original and variation
        # events are automatically refreshed.
        initial_occurrences_count = self.event.occurrences.count()
        self.assertEqual(20, initial_occurrences_count)
        self.assertEqual(models.Event.objects.count(), 1)
        # Make a repeating variation that "takes over" event series from a
        # given time because it inherits its `recurrence_rule`, thus ending
        # the parent event series at this point
        variation_point = self.event.get_future_occurrences()[10]
        variation = self.event.make_variation(variation_point)
        # Confirm variation is saved
        self.assertIsNotNone(variation.pk)
        # Confirm variation and parent are associated correctly
        self.assertNotEqual(self.event.pk, variation.pk)
        self.assertEqual(self.event, variation.parent)
        self.assertTrue(variation.is_variation())
        self.assertFalse(variation.is_original())
        # Now two events
        self.assertEqual(models.Event.objects.count(), 2)
        # Original event occurrences are trimmed from point of variation
        self.assertEqual(11, self.event.occurrences.all().count())
        # Variation event gets remainder of occurrences
        self.assertEqual(9, variation.occurrences.all().count())

    #def test_make_variation_that_splits_parent_series_at_beginning(self):
    #    variation_point = self.event.occurrences.all()[0]
    #    # Sanity-check our starting point
    #    self.assertEqual(20, self.event.occurrences.all().count())
    #    self.assertTrue(variation_point.starts
    #                    in get_occurrences_start_datetimes_for_event(self.event))
    #    # Create multi-day variation that starts at parent's start
    #    variation = self.event.make_variation(
    #        variation_point,
    #        end_repeat=variation_point.starts + timedelta(days=7))
    #    # Confirm results
    #    self.assertEqual(7, variation.occurrences.all().count())
    #    self.assertTrue(self.event.starts
    #                    in get_occurrences_start_datetimes_for_event(variation))
    #    self.assertTrue(variation_point.starts
    #                    in get_occurrences_start_datetimes_for_event(variation))
    #    self.assertEqual(13, self.event.occurrences.all().count())
    #    self.assertFalse(self.event.starts
    #                     in get_occurrences_start_datetimes_for_event(self.event))
    #    self.assertFalse(self.event.starts + timedelta(days=6)
    #                     in get_occurrences_start_datetimes_for_event(self.event))
    #    self.assertTrue(self.event.starts + timedelta(days=7)
    #                    in get_occurrences_start_datetimes_for_event(self.event))

    def test_make_variation_that_extends_beyond_parent_series(self):
        variation_point = self.event.occurrences.all()[10]
        # Sanity-check our starting point
        self.assertEqual(20, self.event.occurrences.all().count())
        self.assertTrue(variation_point.starts
                        in get_occurrences_start_datetimes_for_event(self.event))
        # Create multi-day variation that extends beyond parent's series by
        # overriding parent's `end_repeat`
        variation = self.event.make_variation(
            variation_point,
            end_repeat=self.event.end_repeat + timedelta(days=5))
        # Confirm results
        self.assertEqual(15, variation.occurrences.all().count())
        self.assertTrue(variation_point.starts
                        in get_occurrences_start_datetimes_for_event(variation))
        self.assertEqual(10, self.event.occurrences.all().count())
        self.assertFalse(variation_point.starts
                         in get_occurrences_start_datetimes_for_event(self.event))

    #def test_alter_variation_recurrence_rule(self):
    #    variation_point = self.event.occurrences.all()[10]
    #    # Make repeating variation that splits parent event series
    #    variation = self.event.make_variation(variation_point)
    #    self.assertEqual(10, variation.occurrences.count())
    #    self.assertEqual(10, self.event.occurrences.count())
    #    # Alter variation not to repeat, should re-instate most of parent's
    #    # series
    #    variation.recurrence_rule = None
    #    variation.save()
    #    self.assertEqual(1, variation.occurrences.count())
    #    self.assertEqual(19, self.event.occurrences.count())

    def test_must_regenerate_events_if_recurrence_rule_changed(self):
        # Updating the recurrence rule without refreshing occurrences is not
        # allowed. Decoupled events cannot repeat.
        variation = self.event.make_variation(
            self.event.get_future_occurrences()[10])
        variation.recurrence_rule = 'FREQ=WEEKLY'
        message = ('Cannot save changes to event occurrence fields on an'
                   ' existing event without regenerating occurrences')
        with self.assertRaisesMessage(AssertionError, message):
            variation.save(regenerate_occurrences=False)

    def test_remove_recurrence_rule(self):
        # Removing the recurrence rule without making any other changes is not
        # allowed. This would be a no-op.
        self.event.recurrence_rule = None
        message = ('Cannot save changes to event occurrence fields on an'
                   ' existing event without regenerating occurrences')
        with self.assertRaisesMessage(AssertionError, message):
            self.event.save(regenerate_occurrences=False)

    def test_occurrences_not_regenerated_unnecessarily(self):
        # Occurrences will be updated instead of being recreated when the
        # occurrence parameters are not changed.
        variation = self.event.make_variation(
            self.event.get_future_occurrences()[10])
        # Confirm event and variation have expected occurrences
        self.assertEqual(self.event.get_future_occurrences().count(), 10)
        self.assertEqual(variation.get_future_occurrences().count(), 8)
        # Change a field which does not trigger regeneration of occurrences
        pks = set(
            variation.get_future_occurrences().values_list('pk', flat=True))
        variation.title = 'title'
        variation.save()
        # No changes to existing occurrence instances
        self.assertFalse(pks.difference(set(
            variation.get_future_occurrences().values_list('pk', flat=True))))

    def test_occurrences_regenerated_when_starts_changed(self):
        variation = self.event.make_variation(
            self.event.get_future_occurrences()[10])
        # Confirm event and variation have expected occurrences
        self.assertEqual(self.event.get_future_occurrences().count(), 10)
        self.assertEqual(variation.get_future_occurrences().count(), 8)
        # Occurrences will be recreated when `starts` is changed.
        pks = set(
            variation.get_future_occurrences().values_list('pk', flat=True))
        variation.starts += timedelta(minutes=30)
        variation.save()
        # New primary keys for regenerated occurrences
        self.assertFalse(pks.intersection(set(
            variation.get_future_occurrences().values_list('pk', flat=True))))

    def test_regenerate_occurrences_recurrence_rule(self):
        variation = self.event.make_variation(self.event.occurrences.all()[4])
        # Confirm event and variation have expected occurrences
        self.assertEqual(variation.occurrences.count(), 16)
        self.assertEqual(self.event.occurrences.count(), 4)
        # Occurrences will be recreated when `recurrence_rule` is changed.
        pks = set(variation.occurrences.values_list('pk', flat=True))
        variation.recurrence_rule = 'FREQ=WEEKLY'
        variation.save()
        self.assertEqual(variation.occurrences.count(), 3)
        self.assertEqual(self.event.occurrences.count(), 4)
        # New primary keys for regenerated occurrences
        self.assertFalse(pks.intersection(set(
            variation.occurrences.values_list('pk', flat=True))))

    #def test_reduce_variation_end_repeat(self):
    #    variation_point = self.event.occurrences.all()[10]
    #    vp_plus_5 = self.event.occurrences.all()[15]
    #    # Vestigial repeat events are deleted when `end_repeat` is reduced.
    #    variation = self.event.make_variation(variation_point)
    #    self.assertEqual(10, variation.occurrences.count())
    #    self.assertTrue(vp_plus_5.starts in
    #    get_occurrences_start_datetimes_for_event(variation))
    #    self.assertEqual(10, self.event.occurrences.count())
    #    self.assertFalse(vp_plus_5.starts in
    #    get_occurrences_start_datetimes_for_event(self.event))
    #    # Reduce variation end repeat
    #    variation.end_repeat -= timedelta(days=5)
    #    variation.save()
    #    self.assertEqual(5, variation.occurrences.count())
    #    self.assertFalse(vp_plus_5.starts in
    #    get_occurrences_start_datetimes_for_event(variation))
    #    self.assertEqual(15, self.event.occurrences.count())
    #    self.assertTrue(vp_plus_5.starts in
    #    get_occurrences_start_datetimes_for_event(self.event))

    def test_create_missing_event_occurrences(self):
        self.assertEqual(len(self.event.missing_occurrence_datetimes()), 0)
        # Delete a few occurrences to simulate "missing" ones
        self.event.occurrences.filter(
            starts__gte=self.event.occurrences.all()[5].starts).delete()
        self.assertEqual(len(self.event.missing_occurrence_datetimes()), 15)
        call_command('create_event_occurrences')
        self.assertEqual(len(self.event.missing_occurrence_datetimes()), 0)
        self.assertEqual(self.event.get_future_occurrences().count(), 19)
        self.assertEqual(models.Event.objects.count(), 1)


class Views(WebTest):
    def test_index(self):
        response = self.app.get(reverse('icekit_events_index'))
        response.mustcontain('There are no events.')


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
