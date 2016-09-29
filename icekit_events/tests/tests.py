# -*- encoding: utf8 -*-
"""
Tests for ``icekit_events`` app.
"""

# WebTest API docs: http://webtest.readthedocs.org/en/latest/api.html

from timezone import timezone
from datetime import datetime, timedelta
import six
import json

from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.contenttypes.models import ContentType
from django.core.exceptions import ValidationError
from django.core.management import call_command
from django.core.urlresolvers import reverse
from django.forms.models import fields_for_model
from django.test import TestCase
from django.test.utils import override_settings

from django_dynamic_fixture import G
from django_webtest import WebTest

from icekit_events import appsettings, forms, models
from icekit_events.models import get_occurrence_times_for_event
from icekit_events.tests import models as test_models
from icekit_events.utils import time


class TestAdmin(WebTest):

    def setUp(self):
        self.User = get_user_model()
        self.superuser = G(
            self.User,
            is_staff=True,
            is_superuser=True,
        )
        self.superuser.set_password('abc123')
        self.start = time.round_datetime(
            when=timezone.now(),
            precision=timedelta(minutes=1),
            rounding=time.ROUND_DOWN)
        self.end = self.start + timedelta(minutes=45)

    def test_urls(self):
        response = self.app.get(
            reverse('admin:icekit_events_recurrencerule_changelist'),
            user=self.superuser,
        )
        self.assertEqual(200, response.status_code)

    def test_create_event(self):
        # Load admin Add page, which lists polymorphic event child models
        response = self.app.get(
            reverse('admin:icekit_events_event_add'),
            user=self.superuser,
        )
        # Choose event type from polymorphic child event choices
        form = response.forms[0]
        ct_id = ContentType.objects.get_for_model(models.Event).pk
        form['ct_id'].select(ct_id)
        response = form.submit().follow()  # Follow to get "?ct_id=" GET param
        # Fill in and submit actual Event admin add form
        form = response.forms[0]
        form['title'].value = u"Test Event"
        response = form.submit()
        self.assertEqual(302, response.status_code)
        response = response.follow()
        event = models.Event.objects.get(title=u"Test Event")
        self.assertEqual(0, event.repeat_generators.count())
        self.assertEqual(0, event.occurrences.count())

    def test_event_with_eventrepeatsgenerators(self):
        event = G(
            models.Event,
            title='Test Event',
        )
        response = self.app.get(
            reverse('admin:icekit_events_event_change', args=(event.pk,)),
            user=self.superuser,
        )
        #######################################################################
        # Add "Daily" repeat generator, spans 1 week
        #######################################################################
        repeat_end = self.start + timedelta(days=7)
        form = response.forms[0]
        form['repeat_generators-0-recurrence_rule_0'].select('1')
        form['repeat_generators-0-recurrence_rule_1'].value = 'every day'
        form['repeat_generators-0-recurrence_rule_2'].value = "RRULE:FREQ=DAILY"
        form['repeat_generators-0-start_0'].value = \
            self.start.strftime('%Y-%m-%d')
        form['repeat_generators-0-start_1'].value = \
            self.start.strftime('%H:%M:%S')
        form['repeat_generators-0-end_0'].value = \
            self.end.strftime('%Y-%m-%d')
        form['repeat_generators-0-end_1'].value = \
            self.end.strftime('%H:%M:%S')
        form['repeat_generators-0-repeat_end_0'].value = \
            repeat_end.strftime('%Y-%m-%d')
        form['repeat_generators-0-repeat_end_1'].value = \
            repeat_end.strftime('%H:%M:%S')
        response = form.submit(name='_continue')
        # Check occurrences created
        event = models.Event.objects.get(pk=event.pk)
        self.assertEqual(1, event.repeat_generators.count())
        self.assertEqual(7, event.occurrences.count())
        self.assertEqual(
            self.start, event.occurrences.all()[0].start)
        self.assertEqual(
            self.end, event.occurrences.all()[0].end)
        self.assertEqual(
            self.start + timedelta(days=6), event.occurrences.all()[6].start)
        self.assertEqual(
            self.end + timedelta(days=6), event.occurrences.all()[6].end)
        #######################################################################
        # Add "Daily on weekends" all-day repeat generator, no repeat end
        #######################################################################
        form = response.follow().forms[0]
        form['repeat_generators-1-recurrence_rule_0'].select('3')
        form['repeat_generators-1-recurrence_rule_1'].value = \
            'every day on Saturday, Sunday'
        form['repeat_generators-1-recurrence_rule_2'].value = \
            "RRULE:FREQ=DAILY;BYDAY=SA,SU"
        form['repeat_generators-1-is_all_day'].value = True
        form['repeat_generators-1-start_0'].value = \
            self.start.strftime('%Y-%m-%d')
        form['repeat_generators-1-start_1'].value = '00:00:00'
        form['repeat_generators-1-end_0'].value = \
            self.start.strftime('%Y-%m-%d')  # NOTE: end date == start date
        form['repeat_generators-1-end_1'].value = '00:00:00'
        response = form.submit('_continue')
        # Check occurrences created
        event = models.Event.objects.get(pk=event.pk)
        daily_generator = event.repeat_generators.all()[0]
        daily_wend_generator = event.repeat_generators.all()[1]
        daily_occurrences = event.occurrences.filter(generator=daily_generator)
        daily_wend_occurrences = event.occurrences.filter(
            generator=daily_wend_generator)
        self.assertEqual(2, event.repeat_generators.count())
        self.assertEqual(7, daily_occurrences.count())
        self.assertEqual(
            13 * 2, daily_wend_occurrences.count())
        self.assertEqual(
            5,  # Saturday
            daily_wend_occurrences[0].start.weekday())
        self.assertEqual(
            6,  # Sunday
            daily_wend_occurrences[1].start.weekday())
        # Start and end dates of all-day occurrences are zeroed
        self.assertEqual(
            models.zero_datetime(daily_wend_occurrences[0].start),
            daily_wend_occurrences[0].start)
        self.assertEqual(
            models.zero_datetime(daily_wend_occurrences[0].end),
            daily_wend_occurrences[0].end)
        #######################################################################
        # Delete "Daily" repeat generator
        #######################################################################
        form = response.follow().forms[0]
        form['repeat_generators-0-DELETE'].value = True
        response = form.submit('_continue')
        event = models.Event.objects.get(pk=event.pk)
        self.assertEqual(1, event.repeat_generators.count())
        self.assertEqual(13 * 2, event.occurrences.count())

    def test_event_with_user_modified_occurrences(self):
        event = G(
            models.Event,
            title='Test Event',
        )
        response = self.app.get(
            reverse('admin:icekit_events_event_change', args=(event.pk,)),
            user=self.superuser,
        )
        self.assertEqual(0, event.occurrences.count())
        #######################################################################
        # Add timed occurrence manually
        #######################################################################
        form = response.forms[0]
        form['occurrences-0-start_0'].value = \
            self.start.strftime('%Y-%m-%d')
        form['occurrences-0-start_1'].value = \
            self.start.strftime('%H:%M:%S')
        form['occurrences-0-end_0'].value = \
            self.end.strftime('%Y-%m-%d')
        form['occurrences-0-end_1'].value = \
            self.end.strftime('%H:%M:%S')
        response = form.submit('_continue')
        self.assertEqual(1, event.occurrences.count())
        timed_occurrence = event.occurrences.all()[0]
        self.assertTrue(timed_occurrence.is_user_modified)
        self.assertEqual(
            self.start, timed_occurrence.start)
        self.assertEqual(
            self.end, timed_occurrence.end)
        #######################################################################
        # Add all-day occurrence manually
        #######################################################################
        form = response.follow().forms[0]
        all_day_start = self.start + timedelta(days=3)
        form['occurrences-1-start_0'].value = \
            all_day_start.strftime('%Y-%m-%d')
        form['occurrences-1-start_1'].value = '00:00:00'
        form['occurrences-1-end_0'].value = \
            all_day_start.strftime('%Y-%m-%d')
        form['occurrences-1-end_1'].value = '00:00:00'
        form['occurrences-1-is_all_day'].value = True
        response = form.submit('_continue')
        event = models.Event.objects.get(pk=event.pk)
        self.assertEqual(2, event.occurrences.count())
        all_day_occurrence = event.occurrences.all()[1]
        self.assertTrue(timed_occurrence.is_user_modified)
        self.assertEqual(
            models.zero_datetime(all_day_start), all_day_occurrence.start)
        self.assertEqual(
            models.zero_datetime(all_day_start), all_day_occurrence.end)
        # Start and end dates of all-day occurrences are zeroed
        self.assertEqual(
            models.zero_datetime(all_day_occurrence.start),
            all_day_occurrence.start)
        self.assertEqual(
            models.zero_datetime(all_day_occurrence.end),
            all_day_occurrence.end)
        #######################################################################
        # Cancel first (timed) event
        #######################################################################
        form = response.follow().forms[0]
        form['occurrences-0-cancel_reason'].value = 'Sold out'
        response = form.submit('_continue')
        self.assertEqual(2, event.occurrences.count())
        timed_occurrence = event.occurrences.all()[0]
        self.assertEqual('Sold out', timed_occurrence.cancel_reason)
        self.assertTrue(timed_occurrence.is_cancelled)
        #######################################################################
        # Delete second (all-day) event
        #######################################################################
        form = response.follow().forms[0]
        form['occurrences-1-DELETE'].value = True
        response = form.submit('_continue')
        self.assertEqual(1, event.occurrences.count())

    def test_event_with_repeatsgenerators_and_user_modified_occurrences(self):
        event = G(
            models.Event,
            title='Test Event',
        )
        G(
            models.EventRepeatsGenerator,
            event=event,
            start=self.start,
            end=self.end,
            recurrence_rule='FREQ=WEEKLY',
            repeat_end=self.start + timedelta(weeks=10),
        )
        self.assertEqual(10, event.occurrences.count())
        self.assertEqual(10, event.occurrences.generated().count())
        response = self.app.get(
            reverse('admin:icekit_events_event_change', args=(event.pk,)),
            user=self.superuser,
        )
        first_occurrence = event.occurrences.all()[0]
        #######################################################################
        # Add occurrence manually
        #######################################################################
        form = response.forms[0]
        extra_occurrence_start = (first_occurrence.start - timedelta(days=3)) \
            .astimezone(timezone.get_current_timezone())
        extra_occurrence_end = (first_occurrence.end - timedelta(days=3)) \
            .astimezone(timezone.get_current_timezone())
        form['occurrences-10-start_0'].value = \
            extra_occurrence_start.strftime('%Y-%m-%d')
        form['occurrences-10-start_1'].value = \
            extra_occurrence_start.strftime('%H:%M:%S')
        form['occurrences-10-end_0'].value = \
            extra_occurrence_end.strftime('%Y-%m-%d')
        form['occurrences-10-end_1'].value = \
            extra_occurrence_end.strftime('%H:%M:%S')
        response = form.submit('_continue')
        self.assertEqual(10 + 1, event.occurrences.count())
        extra_occurrence = event.occurrences.all()[0]
        self.assertTrue(extra_occurrence.is_user_modified)
        self.assertFalse(extra_occurrence.is_generated)
        self.assertEqual(
            extra_occurrence_start, extra_occurrence.start)
        self.assertEqual(
            extra_occurrence_end, extra_occurrence.end)
        #######################################################################
        # Adjust start time of a generated occurrence
        #######################################################################
        form = response.follow().forms[0]
        shifted_occurrence = event.occurrences.all()[6]
        self.assertFalse(shifted_occurrence.is_user_modified)
        shifted_occurrence_start = \
            (shifted_occurrence.start + timedelta(minutes=30)) \
            .astimezone(timezone.get_current_timezone())
        form['occurrences-6-start_0'].value = \
            shifted_occurrence_start.strftime('%Y-%m-%d')
        form['occurrences-6-start_1'].value =\
            shifted_occurrence_start.strftime('%H:%M:%S')
        response = form.submit('_continue')
        event = models.Event.objects.get(pk=event.pk)
        self.assertEqual(10 + 1, event.occurrences.count())
        shifted_occurrence = models.Occurrence.objects.get(
            pk=shifted_occurrence.pk)
        self.assertTrue(shifted_occurrence.is_user_modified)
        self.assertTrue(shifted_occurrence.is_generated)
        self.assertEqual(
            shifted_occurrence_start, shifted_occurrence.start)
        self.assertEqual(
            shifted_occurrence_start + timedelta(minutes=15),
            shifted_occurrence.end)
        #######################################################################
        # Convert a timed generated occurrence to all-day
        #######################################################################
        form = response.follow().forms[0]
        converted_occurrence = event.occurrences.all()[2]
        self.assertFalse(converted_occurrence.is_user_modified)
        form['occurrences-2-is_all_day'].value = True
        response = form.submit('_continue')
        event = models.Event.objects.get(pk=event.pk)
        self.assertEqual(10 + 1, event.occurrences.count())
        converted_occurrence = models.Occurrence.objects.get(
            pk=converted_occurrence.pk)
        self.assertTrue(converted_occurrence.is_user_modified)
        self.assertTrue(converted_occurrence.is_generated)
        self.assertTrue(converted_occurrence.is_all_day)
        #######################################################################
        # Cancel a generated occurrence
        #######################################################################
        form = response.follow().forms[0]
        cancelled_occurrence = event.occurrences.all()[3]
        self.assertFalse(cancelled_occurrence.is_user_modified)
        form['occurrences-3-cancel_reason'].value = 'Sold out'
        response = form.submit('_continue')
        event = models.Event.objects.get(pk=event.pk)
        self.assertEqual(10 + 1, event.occurrences.count())
        cancelled_occurrence = models.Occurrence.objects.get(
            pk=cancelled_occurrence.pk)
        self.assertTrue(cancelled_occurrence.is_user_modified)
        self.assertTrue(cancelled_occurrence.is_generated)
        self.assertTrue(cancelled_occurrence.is_cancelled)
        self.assertEqual('Sold out', cancelled_occurrence.cancel_reason)
        #######################################################################
        # Delete a generated occurrence (should be regenerated)
        #######################################################################
        self.assertEqual(11, event.occurrences.count())
        form = response.follow().forms[0]
        form['occurrences-8-DELETE'].value = True
        response = form.submit('_continue')
        self.assertEqual(10, event.occurrences.count())
        #######################################################################
        # Regenerate event occurrences and confirm user modifications intact
        #######################################################################
        self.assertEqual(1, event.occurrences.added_by_user().count())
        self.assertEqual(
            9,  # Down one, since we deleted a generated occurrence above
            event.occurrences.generated().count())
        self.assertEqual(4, event.occurrences.modified_by_user().count())
        self.assertEqual(6, event.occurrences.unmodified_by_user().count())
        self.assertEqual(6, event.occurrences.regeneratable().count())
        # Regenerate!
        event.regenerate_occurrences()
        self.assertEqual(11, event.occurrences.count())
        self.assertEqual(1, event.occurrences.added_by_user().count())
        self.assertEqual(
            10,  # Deleted generated occurrence is recreated
            event.occurrences.generated().count())
        self.assertEqual(4, event.occurrences.modified_by_user().count())
        self.assertEqual(7, event.occurrences.unmodified_by_user().count())
        self.assertEqual(7, event.occurrences.regeneratable().count())

    def test_event_publishing(self):
        #######################################################################
        # Create unpublished (draft) event
        #######################################################################
        event = G(
            models.Event,
            title='Test Event',
        )
        self.assertTrue(event.is_draft)
        self.assertEqual([event], list(models.Event.objects.draft()))
        self.assertIsNone(event.get_published())
        self.assertEqual([], list(models.Event.objects.published()))
        self.assertEqual(0, event.repeat_generators.count())
        self.assertEqual(0, event.occurrences.count())
        view_response = self.app.get(
            reverse('icekit_events_event_detail', args=(event.pk,)),
            expect_errors=404)
        #######################################################################
        # Publish event, nothing much to clone yet
        #######################################################################
        response = self.app.get(
            reverse('admin:icekit_events_event_publish', args=(event.pk,)),
            user=self.superuser,
        )
        self.assertEqual(302, response.status_code)
        event = models.Event.objects.get(pk=event.pk)
        self.assertTrue(event.is_draft)
        self.assertEqual([event], list(models.Event.objects.draft()))
        self.assertIsNotNone(event.get_published())
        published_event = event.get_published()
        self.assertEqual(
            [published_event], list(models.Event.objects.published()))
        self.assertEqual(event.title, published_event.title)
        self.assertEqual(0, published_event.repeat_generators.count())
        self.assertEqual(0, published_event.repeat_generators.count())
        view_response = self.app.get(
            reverse('icekit_events_event_detail', args=(published_event.pk,)))
        self.assertEqual(200, view_response.status_code)
        self.assertTrue('Test Event' in view_response.content)
        #######################################################################
        # Update draft event with repeat generators and manual occurrences
        #######################################################################
        response = self.app.get(
            reverse('admin:icekit_events_event_change', args=(event.pk,)),
            user=self.superuser,
        )
        form = response.forms[0]
        # Update event title
        form['title'].value += ' - Update 1'
        # Add weekly repeat for 4 weeks
        repeat_end = self.start + timedelta(days=28)
        form['repeat_generators-0-recurrence_rule_0'].select('4')
        form['repeat_generators-0-recurrence_rule_1'].value = 'weekly'
        form['repeat_generators-0-recurrence_rule_2'].value = "FREQ=WEEKLY"
        form['repeat_generators-0-start_0'].value = \
            self.start.strftime('%Y-%m-%d')
        form['repeat_generators-0-start_1'].value = \
            self.start.strftime('%H:%M:%S')
        form['repeat_generators-0-end_0'].value = \
            self.end.strftime('%Y-%m-%d')
        form['repeat_generators-0-end_1'].value = \
            self.end.strftime('%H:%M:%S')
        form['repeat_generators-0-repeat_end_0'].value = \
            repeat_end.strftime('%Y-%m-%d')
        form['repeat_generators-0-repeat_end_1'].value = \
            repeat_end.strftime('%H:%M:%S')
        # Add ad-hoc occurrence
        extra_occurrence_start = (self.start - timedelta(days=30)) \
            .astimezone(timezone.get_current_timezone())
        extra_occurrence_end = extra_occurrence_start + timedelta(hours=3)
        form['occurrences-0-start_0'].value = \
            extra_occurrence_start.strftime('%Y-%m-%d')
        form['occurrences-0-start_1'].value = \
            extra_occurrence_start.strftime('%H:%M:%S')
        form['occurrences-0-end_0'].value = \
            extra_occurrence_end.strftime('%Y-%m-%d')
        form['occurrences-0-end_1'].value = \
            extra_occurrence_end.strftime('%H:%M:%S')
        # Submit form
        response = form.submit(name='_continue')
        self.assertEqual(302, response.status_code)
        event = models.Event.objects.get(pk=event.pk)
        # Convert a generated occurrence to all-day
        form = response.follow().forms[0]
        converted_occurrence = event.occurrences.all()[3]
        self.assertFalse(converted_occurrence.is_user_modified)
        form['occurrences-3-is_all_day'].value = True
        response = form.submit('_continue')
        self.assertEqual(302, response.status_code)
        #######################################################################
        # Republish event, ensure everything is cloned
        #######################################################################
        # First check that published copy remains unchanged so far
        published_event = models.Event.objects.get(pk=published_event.pk)
        self.assertEqual('Test Event', published_event.title)
        self.assertEqual(0, published_event.repeat_generators.count())
        self.assertEqual(0, published_event.occurrences.count())
        view_response = self.app.get(
            reverse('icekit_events_event_detail', args=(published_event.pk,)))
        self.assertEqual(200, view_response.status_code)
        self.assertFalse('Test Event - Update 1' in view_response.content)
        # Republish event
        response = self.app.get(
            reverse('admin:icekit_events_event_publish', args=(event.pk,)),
            user=self.superuser,
        )
        self.assertEqual(302, response.status_code)
        event = models.Event.objects.get(pk=event.pk)
        # Original published event record has been deleted
        self.assertEqual(
            0, models.Event.objects.filter(pk=published_event.pk).count())
        # Confirm cloning of published event's repeat rules and occurrences
        published_event = event.get_published()
        self.assertEqual('Test Event - Update 1', published_event.title)
        self.assertEqual(
            event.repeat_generators.count(),
            published_event.repeat_generators.count())
        for draft_generator, published_generator in zip(
                event.repeat_generators.all(),
                published_event.repeat_generators.all()
        ):
            self.assertNotEqual(draft_generator.pk, published_generator.pk)
            self.assertEqual(event, draft_generator.event)
            self.assertEqual(published_event, published_generator.event)
            self.assertEqual(
                draft_generator.recurrence_rule,
                published_generator.recurrence_rule)
        for draft_occurrence, published_occurrence in zip(
                event.occurrences.all(), published_event.occurrences.all()):
            self.assertNotEqual(draft_occurrence.pk, published_occurrence.pk)
            self.assertEqual(event, draft_occurrence.event)
            self.assertEqual(published_event, published_occurrence.event)
            self.assertEqual(
                draft_occurrence.start, published_occurrence.start)
            self.assertEqual(
                draft_occurrence.end, published_occurrence.end)
            self.assertEqual(
                draft_occurrence.is_all_day, published_occurrence.is_all_day)
            self.assertEqual(
                draft_occurrence.is_user_modified,
                published_occurrence.is_user_modified)
            self.assertEqual(
                draft_occurrence.is_cancelled,
                published_occurrence.is_cancelled)
            self.assertEqual(
                draft_occurrence.is_hidden,
                published_occurrence.is_hidden)
            self.assertEqual(
                draft_occurrence.cancel_reason,
                published_occurrence.cancel_reason)
            self.assertEqual(
                draft_occurrence.original_start,
                published_occurrence.original_start)
            self.assertEqual(
                draft_occurrence.original_end,
                published_occurrence.original_end)
        view_response = self.app.get(
            reverse('icekit_events_event_detail', args=(published_event.pk,)))
        self.assertEqual(200, view_response.status_code)
        self.assertTrue('Test Event - Update 1' in view_response.content)
        #######################################################################
        # Unpublish event
        #######################################################################
        # Unpublish event
        response = self.app.get(
            reverse('admin:icekit_events_event_unpublish', args=(event.pk,)),
            user=self.superuser,
        )
        self.assertEqual(302, response.status_code)
        event = models.Event.objects.get(pk=event.pk)
        self.assertTrue(event.is_draft)
        self.assertIsNone(event.get_published())
        view_response = self.app.get(
            reverse('icekit_events_event_detail', args=(published_event.pk,)),
            expect_errors=404)

    def test_admin_calendar(self):
        event = G(
            models.Event,
            title='Test Event',
        )
        repeat_end = self.end + timedelta(days=7)
        G(
            models.EventRepeatsGenerator,
            event=event,
            start=self.start,
            end=self.end,
            recurrence_rule="FREQ=DAILY;BYDAY=SA,SU",
            repeat_end=repeat_end,
        )
        self.assertEqual(2, event.occurrences.count())
        #######################################################################
        # Fetch calendar HTML page
        #######################################################################
        response = self.app.get(
            reverse('admin:icekit_events_event_calendar'),
            user=self.superuser,
        )
        self.assertEqual(200, response.status_code)
        self.assertEqual('text/html; charset=utf-8', response['content-type'])
        self.assertTrue("<div id='calendar'></div>" in response.content)
        self.assertTrue(
            reverse('admin:icekit_events_event_calendar_data')
            in response.content)
        #######################################################################
        # Fetch calendar JSON data
        #######################################################################
        response = self.app.get(
            reverse('admin:icekit_events_event_calendar_data'),
            {
                'start': self.start.date(),
                'end': repeat_end.date() + timedelta(days=1),
            },
            user=self.superuser,
        )
        self.assertEqual(200, response.status_code)
        self.assertEqual('application/json', response['content-type'])
        data = json.loads(response.content)
        self.assertEqual(2, len(data))
        def format_dt_like_fullcalendar(dt):
            formatted = dt.astimezone(timezone.get_current_timezone()) \
                .strftime('%Y-%m-%dT%H:%M:%S%z')
            # FullCalendar includes ':' between hour & minute portions of the
            # timzone offset. There's no way to do this directly with Python's
            # `strftime` formatting...
            formatted = formatted[:-2] + ':' + formatted[-2:]
            return formatted
        for entry, occurrence in zip(data, event.occurrences.all()):
            self.assertEqual(
                occurrence.event.title,
                entry['title'])
            self.assertEqual(
                format_dt_like_fullcalendar(occurrence.start),
                entry['start'])
            self.assertEqual(
                format_dt_like_fullcalendar(occurrence.end),
                entry['end'])
            self.assertEqual(
                occurrence.is_all_day,
                entry['allDay'])

    # TODO Test Event cloning


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
        self.assertEqual(
            (None, None), event.get_occurrences_range())


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
        self.assertRaisesRegexp(
            models.GeneratorException,
            r'End date/time must be after or equal to start date/time.*',
            models.EventRepeatsGenerator.objects.create,
            start=self.start,
            end=self.start - timedelta(seconds=1),
        )
        # End can equal start
        generator = models.EventRepeatsGenerator.objects.create(
            start=self.start,
            end=self.start,
            event=G(models.Event),
        )
        self.assertEqual(timedelta(), generator.duration)
        # Repeat end cannot be set without a recurrence rule
        self.assertRaisesRegexp(
            models.GeneratorException,
            'Recurrence rule must be set if a repeat end date/time is set.*',
            models.EventRepeatsGenerator.objects.create,
            start=self.start,
            end=self.start + timedelta(seconds=1),
            repeat_end=self.start + timedelta(seconds=1),
        )
        # Repeat end cannot come before start
        self.assertRaisesRegexp(
            models.GeneratorException,
            'Repeat end date/time must be after or equal to start date/time.*',
            models.EventRepeatsGenerator.objects.create,
            start=self.start,
            end=self.start + timedelta(seconds=1),
            recurrence_rule='FREQ=DAILY',
            repeat_end=self.start - timedelta(seconds=1),
        )
        # All-day generator must have a start datetime with 00:00:00 time
        self.assertRaisesRegexp(
            models.GeneratorException,
            'Start date/time must be at 00:00:00 hours/minutes/seconds for'
            ' all-day generators.*',
            models.EventRepeatsGenerator.objects.create,
            is_all_day=True,
            start=self.start.replace(hour=0, minute=0, second=1),
            end=self.start.replace(hour=0, minute=0, second=1),
        )
        # All-day generator duration must be a multiple of whole days
        models.EventRepeatsGenerator.objects.create(
            is_all_day=True,
            start=self.start,
            end=self.start + timedelta(hours=24),
            event=G(models.Event),
        )
        self.assertRaisesRegexp(
            models.GeneratorException,
            'Duration between start and end times must be multiples of a day'
            ' for all-day generators',
            models.EventRepeatsGenerator.objects.create,
            is_all_day=True,
            start=self.start,
            end=self.start + timedelta(hours=24, seconds=1),
        )

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
            next(start_and_end_times))
        self.assertEqual(
            (self.start + timedelta(days=1), self.end + timedelta(days=1)),
            next(start_and_end_times))
        self.assertEqual(
            (self.start + timedelta(days=2), self.end + timedelta(days=2)),
            next(start_and_end_times))
        for i in range(16):
            next(start_and_end_times)
        self.assertEqual(
            (self.start + timedelta(days=19), self.end + timedelta(days=19)),
            next(start_and_end_times))
        # Default ``appsettings.REPEAT_LIMIT`` is 13 weeks
        for i in range(13 * 7 - 20):
            next(start_and_end_times)
        self.assertEqual(
            (self.start + timedelta(days=91), self.end + timedelta(days=91)),
            next(start_and_end_times))


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
        occurrence_starts, occurrence_ends = get_occurrence_times_for_event(event)
        first_occurrence = event.occurrences.all()[0]
        for days_hence in range(20):
            start = first_occurrence.start + timedelta(days=days_hence)
            self.assertTrue(start in occurrence_starts,
                            "Missing start time %d days hence" % days_hence)
            end = first_occurrence.end + timedelta(days=days_hence)
            self.assertTrue(end in occurrence_ends,
                            "Missing end time %d days hence" % days_hence)
        # Confirm Event correctly returns first & last occurrences
        self.assertEqual(
            self.start, event.get_occurrences_range()[0].start)
        self.assertEqual(
            self.end + timedelta(days=19),
            event.get_occurrences_range()[1].end)

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
        occurrence_starts, __ = get_occurrence_times_for_event(event)
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
