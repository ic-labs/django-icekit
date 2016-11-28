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
from django.db.models import Count, Min, Max
from django.http import HttpResponse, JsonResponse
from django.template.defaultfilters import slugify
from django.template.response import TemplateResponse
from django.utils.timezone import get_current_timezone
from django.views.decorators.csrf import csrf_exempt

from icekit.admin_mixins import FluentLayoutsMixin
from icekit.content_collections.admin import TitleSlugAdmin
from icekit.plugins.base import BaseChildModelPlugin

from icekit.plugins.base import PluginMount

from icekit.admin import (
    ChildModelFilter, ChildModelPluginPolymorphicParentModelAdmin)
from icekit.utils.admin.urls import admin_link
from polymorphic.admin import PolymorphicChildModelAdmin
from timezone import timezone as djtz  # django-timezone

from icekit.publishing import admin as publishing_admin

from . import admin_forms, forms, models

logger = logging.getLogger(__name__)


class EventRepeatGeneratorsInline(admin.TabularInline):
    model = models.EventRepeatsGenerator
    form = admin_forms.BaseEventRepeatsGeneratorForm
    extra = 1
    fields = ('is_all_day', 'start', 'end', 'recurrence_rule', 'repeat_end',)
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
    fields = ('is_all_day', 'start', 'end', 'is_user_modified', 'external_ref', 'status')
    exclude = (
        'generator', 'is_generated',
        # is_hidden and is_cancelled aren't implemented yet,
        # so hiding relevant fields
        'is_hidden', 'is_cancelled', 'cancel_reason'
    )
    extra = 1
    readonly_fields = ('is_user_modified', 'external_ref')  # 'is_cancelled',)


class EventChildAdmin(
    PolymorphicChildModelAdmin,
    publishing_admin.PublishingAdmin,
    TitleSlugAdmin
):
    """
    Abstract admin class for polymorphic child event models.
    """
    # base_form = admin_forms.BaseEventForm
    base_model = models.EventBase
    inlines = [
        EventRepeatGeneratorsInline,
        OccurrencesInline,
    ]
    exclude = (
        # Legacy fields, will be removed soon
        'all_day', 'starts', 'ends', 'date_starts', 'date_ends',
        'recurrence_rule', 'end_repeat', 'date_end_repeat', 'is_repeat',
    )
    raw_id_fields = ('part_of', )
    save_on_top = True


class EventChildModelPlugin(six.with_metaclass(
    PluginMount, BaseChildModelPlugin)):
    """
    Mount point for ``EventBase`` child model plugins.
    """
    model_admin = EventChildAdmin


class EventTypeFilter(ChildModelFilter):
    child_model_plugin_class = EventChildModelPlugin


class EventAdmin(ChildModelPluginPolymorphicParentModelAdmin,
                 publishing_admin.PublishingAdmin):
    """
    Polymorphic parent admin for Events.
    """
    base_model = models.EventBase
    list_filter = (
        EventTypeFilter, 'primary_type', 'secondary_types', 'modified', 'show_in_calendar', 'is_drop_in', 'has_tickets_available',
        publishing_admin.PublishingStatusFilter,
        publishing_admin.PublishingPublishedFilter,
    )
    list_display = (
        '__str__', 'child_type_name', 'primary_type', 'modified',
        'publishing_column',
        'part_of_display', 'show_in_calendar', 'has_tickets_available', 'is_drop_in',
        'occurrence_count',
        'first_occurrence', 'last_occurrence',
    )
    search_fields = ('title', 'part_of__title', )

    child_model_plugin_class = EventChildModelPlugin
    child_model_admin = EventChildAdmin

    class Media:
        css = {
            'all': ('icekit_events/bower_components/'
                    'font-awesome/css/font-awesome.css',),
        }

    def get_queryset(self, request):
        return super(EventAdmin, self).get_queryset(request).annotate(
            last_occurrence=Max('occurrences__start'),
            first_occurrence=Min('occurrences__start'),
            occurrence_count=Count('occurrences')
        )

    def occurrence_count(self, inst):
        return inst.occurrence_count
    occurrence_count.admin_order_field = 'occurrence_count'

    def first_occurrence(self, inst):
        return inst.first_occurrence
    first_occurrence.admin_order_field = 'first_occurrence'

    def last_occurrence(self, inst):
        return inst.last_occurrence
    last_occurrence.admin_order_field = 'last_occurrence'

    def part_of_display(self, inst):
        return admin_link(inst.part_of)
    part_of_display.admin_order_field = "part_of__title"
    part_of_display.short_description = "Part of"
    part_of_display.allow_tags = True

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
                name='icekit_events_eventbase_calendar'
            ),
            url(
                r'^calendar_data/$',
                self.admin_site.admin_view(self.calendar_data),
                name='icekit_events_eventbase_calendar_data'
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
            request, 'admin/icekit_events/eventbase/calendar.html', context)

    def calendar_data(self, request):
        """
        Return event data in JSON format for AJAX requests, or a calendar page
        to be loaded in an iframe.
        """
        if 'timezone' in request.GET:
            tz = djtz.get(request.GET.get('timezone'))
        else:
            tz = get_current_timezone()
        start = djtz.localize(
            datetime.datetime.strptime(request.GET['start'], '%Y-%m-%d'), tz)
        end = djtz.localize(
            datetime.datetime.strptime(request.GET['end'], '%Y-%m-%d'), tz)

        all_occurrences = models.Occurrence.objects.draft().overlapping(start, end)

        data = []
        for occurrence in all_occurrences.all():
            data.append(self._calendar_json_for_occurrence(occurrence))
        data = json.dumps(data, cls=DjangoJSONEncoder)
        return HttpResponse(content=data, content_type='application/json')

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
            start = djtz.localize(occurrence.start)
            end = djtz.localize(occurrence.end)
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
            'url': reverse('admin:icekit_events_eventbase_change',
                           args=[occurrence.event.pk]),
            'className': self._calendar_classes_for_occurrence(occurrence),
        }

    def _calendar_classes_for_occurrence(self, occurrence):
        """
        Return css classes to be used in admin calendar JSON
        """
        classes = [slugify(occurrence.event.polymorphic_ctype.name)]

        # quick-and-dirty way to get a color for the EventBase type.
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

class EventWithLayoutsAdmin(EventChildAdmin, FluentLayoutsMixin):
    pass


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
                recurrence_rule, dtstart=djtz.now(), forceset=True)
        except ValueError as e:
            data = {
                'error': six.text_type(e),
            }
        else:
            data = {
                'occurrences': rruleset[:limit]
            }
        return JsonResponse(data)


class EventTypeAdmin(TitleSlugAdmin):
    list_display = TitleSlugAdmin.list_display + ('is_public',)
    list_filter = ('is_public',)


admin.site.register(models.EventBase, EventAdmin)
admin.site.register(models.EventType, EventTypeAdmin)
admin.site.register(models.RecurrenceRule, RecurrenceRuleAdmin)
