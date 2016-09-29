"""
Admin configuration for ``icekit_events`` app.
"""

# Define `list_display`, `list_filter` and `search_fields` for each model.
# These go a long way to making the admin more usable.

from datetime import timedelta
from dateutil import rrule
import datetime
import json
import logging
import six

from django.contrib import admin
from django.core.serializers.json import DjangoJSONEncoder
from django.core.urlresolvers import reverse
from django.http import HttpResponse, JsonResponse
from django.template.defaultfilters import slugify
from django.template.response import TemplateResponse
from django.utils.timezone import get_current_timezone
from django.views.decorators.csrf import csrf_exempt
from icekit.admin import (
    ChildModelFilter, ChildModelPluginPolymorphicParentModelAdmin)
from polymorphic.admin import PolymorphicChildModelAdmin
from timezone import timezone

from icekit.articles.admin import TitleSlugAdmin
from icekit.publishing import admin as publishing_admin

from . import admin_forms, forms, models, plugins

logger = logging.getLogger(__name__)


class EventRepeatGeneratorsInline(admin.TabularInline):
    model = models.EventRepeatsGenerator
    form = admin_forms.BaseEventRepeatsGeneratorForm
    exclude = ('event',)
    extra = 1
    max_num = 3
    formfield_overrides = {
        models.RecurrenceRuleField: {
            'widget': forms.RecurrenceRuleWidget(attrs={
                'rows': 1,
            }),
        },
    }


class OccurrencesInline(admin.TabularInline):
    model = models.Occurrence
    form = admin_forms.BaseOccurrenceForm
    exclude = ('generator', 'is_generated',)
    extra = 1
    readonly_fields = ('is_user_modified', 'is_cancelled',)


class EventChildAdmin(PolymorphicChildModelAdmin,
                      publishing_admin.PublishingAdmin):
    """
    Abstract admin class for polymorphic child event models.
    """
    base_form = admin_forms.BaseEventForm
    base_model = models.Event
    inlines = [
        EventRepeatGeneratorsInline,
        OccurrencesInline,
    ]
    exclude = (
        # Legacy fields, will be removed soon
        'all_day', 'starts', 'ends', 'date_starts', 'date_ends',
        'recurrence_rule', 'end_repeat', 'date_end_repeat', 'is_repeat',
    )
    save_on_top = True


class EventPageChildAdmin(EventChildAdmin, TitleSlugAdmin):
    base_form = admin_forms.BaseEventPageForm
    base_model = models.EventPage


class EventTypeFilter(ChildModelFilter):
    child_model_plugin_class = plugins.EventChildModelPlugin


class EventAdmin(ChildModelPluginPolymorphicParentModelAdmin,
                 publishing_admin.PublishingAdmin):
    base_model = models.Event
    list_filter = (
        EventTypeFilter, 'modified',
        publishing_admin.PublishingStatusFilter,
        publishing_admin.PublishingPublishedFilter,
    )
    list_display = (
        '__str__', 'get_type', 'modified', 'publishing_column')
    search_fields = ('title', )

    child_model_plugin_class = plugins.EventChildModelPlugin
    child_model_admin = EventChildAdmin

    class Media:
        css = {
            'all': ('icekit_events/bower_components/'
                    'font-awesome/css/font-awesome.css',),
        }

    def get_urls(self):
        """
        Add a calendar URL.
        """
        from django.conf.urls import patterns, url
        urls = super(EventAdmin, self).get_urls()
        my_urls = patterns(
            '',
            url(
                r'^calendar/$',
                self.admin_site.admin_view(self.calendar),
                name='icekit_events_event_calendar'
            ),
            url(
                r'^calendar_data/$',
                self.admin_site.admin_view(self.calendar_data),
                name='icekit_events_event_calendar_data'
            ),
        )
        return my_urls + urls

    def calendar(self, request):
        """
        Return a calendar page to be loaded in an iframe.
        """
        context = {
            'is_popup': bool(int(request.GET.get('_popup', 0))),
        }
        return TemplateResponse(
            request, 'admin/icekit_events/event/calendar.html', context)

    def calendar_data(self, request):
        """
        Return event data in JSON format for AJAX requests, or a calendar page
        to be loaded in an iframe.
        """
        if 'timezone' in request.GET:
            tz = timezone.get(request.GET.get('timezone'))
        else:
            tz = get_current_timezone()
        start = timezone.localize(
            datetime.datetime.strptime(request.GET['start'], '%Y-%m-%d'), tz)
        end = timezone.localize(
            datetime.datetime.strptime(request.GET['end'], '%Y-%m-%d'), tz)

        all_occurrences = models.Occurrence.objects.draft().within(start, end)

        data = []
        for occurrence in all_occurrences.all():
            data.append(self._calendar_json_for_occurrence(occurrence))
        data = json.dumps(data, cls=DjangoJSONEncoder)
        return HttpResponse(content=data, content_type='application/json')

    def get_type(self, obj):
        return obj.get_real_concrete_instance_class() \
            ._meta.verbose_name.title()
    get_type.short_description = "type"

    def _calendar_json_for_occurrence(self, occurrence):
        """
        Return JSON for a single Occurrence
        """
        # Slugify the plugin's verbose name for use as a class name.
        if occurrence.is_all_day:
            start = occurrence.start
            # `end` is exclusive according to the doc in
            # http://fullcalendar.io/docs/event_data/Event_Object/, so
            # we need to add 1 day to ``end`` to have the end date
            # included in the calendar.
            end = occurrence.start + timedelta(days=1)
        else:
            start = timezone.localize(occurrence.start)
            end = timezone.localize(occurrence.end)
        if occurrence.is_cancelled and occurrence.cancel_reason:
            title = u"{0} [{1}]".format(
                occurrence.event.title, occurrence.cancel_reason)
        else:
            title = occurrence.event.title
        return {
            'title': title,
            'allDay': occurrence.is_all_day,
            'start': start,
            'end': end,
            'url': reverse('admin:icekit_events_event_change',
                           args=[occurrence.event.pk]),
            'className': self._calendar_classes_for_occurrence(occurrence),
        }

    def _calendar_classes_for_occurrence(self, occurrence):
        """
        Return css classes to be used in admin calendar JSON
        """
        classes = [slugify(occurrence.event.polymorphic_ctype.name)]

        # quick-and-dirty way to get a color for the Event type.
        # There are 12 colors defined in the css file
        classes.append("color-%s" % (
            occurrence.event.polymorphic_ctype_id % 12))

        # Add a class name for the type of event.
        if occurrence.is_all_day:
            classes.append('is-all-day')
        if occurrence.is_user_modified:
            classes.append('is-user-modified')
        if occurrence.is_cancelled:
            classes.append('is-cancelled')

        # if an event isn't published or does not have show_in_calendar ticked,
        # indicate that it is hidden
        if not occurrence.event.show_in_calendar:
            classes.append('do-not-show-in-calendar')

        # Prefix class names with "fcc-" (full calendar class).
        classes = ['fcc-%s' % class_ for class_ in classes]

        return classes


class RecurrenceRuleAdmin(admin.ModelAdmin):
    formfield_overrides = {
        models.RecurrenceRuleField: {'widget': forms.RecurrenceRuleWidget},
    }
    model = models.RecurrenceRule

    def get_urls(self):
        """
        Add a preview URL.
        """
        from django.conf.urls import patterns, url
        urls = super(RecurrenceRuleAdmin, self).get_urls()
        my_urls = patterns(
            '',
            url(
                r'^preview/$',
                self.admin_site.admin_view(self.preview),
                name='icekit_events_recurrencerule_preview'
            ),
        )
        return my_urls + urls

    @csrf_exempt
    def preview(self, request):
        """
        Return a occurrences in JSON format up until the configured limit.
        """
        recurrence_rule = request.POST.get('recurrence_rule')
        limit = int(request.POST.get('limit', 10))
        try:
            rruleset = rrule.rrulestr(
                recurrence_rule, dtstart=timezone.now(), forceset=True)
        except ValueError as e:
            data = {
                'error': six.text_type(e),
            }
        else:
            data = {
                'occurrences': rruleset[:limit]
            }
        return JsonResponse(data)


admin.site.register(models.Event, EventAdmin)
admin.site.register(models.RecurrenceRule, RecurrenceRuleAdmin)
