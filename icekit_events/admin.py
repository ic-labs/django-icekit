# -*- coding: utf-8 -*-

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
from django.contrib.admin import SimpleListFilter
from django.contrib.admin.views.main import ChangeList
from django.core.serializers.json import DjangoJSONEncoder
from django.core.urlresolvers import reverse
from django.db.models import Count, Min, Max
from django.http import HttpResponse, JsonResponse
from django.template.defaultfilters import slugify
from django.template.response import TemplateResponse
from django.utils.timezone import get_current_timezone
from django.views.decorators.csrf import csrf_exempt

from icekit.admin_tools.mixins import FluentLayoutsMixin
from icekit.admin_tools.polymorphic import \
    ChildModelPluginPolymorphicParentModelAdmin
from icekit.content_collections.admin import TitleSlugAdmin
from icekit.plugins.base import BaseChildModelPlugin

from icekit.plugins.base import PluginMount

from icekit.admin import ChildModelFilter, ICEkitInlineAdmin

from icekit.admin_tools.utils import admin_link
from polymorphic.admin import PolymorphicChildModelAdmin
from timezone import timezone as djtz  # django-timezone

from icekit import admin as icekit_admin

from . import admin_forms, forms, models

logger = logging.getLogger(__name__)


class EventRepeatGeneratorsInline(ICEkitInlineAdmin, admin.TabularInline):
    model = models.EventRepeatsGenerator
    form = admin_forms.BaseEventRepeatsGeneratorForm
    extra = 0
    fields = ('is_all_day', 'start', 'end', 'recurrence_rule', 'repeat_end',)
    formfield_overrides = {
        models.RecurrenceRuleField: {
            'widget': forms.RecurrenceRuleWidget(attrs={
                'rows': 1,
            }),
        },
    }


class OccurrencesInline(ICEkitInlineAdmin, admin.TabularInline):
    model = models.Occurrence
    form = admin_forms.BaseOccurrenceForm
    fields = ('is_all_day', 'start', 'end', 'is_protected_from_regeneration', 'external_ref', 'status')
    exclude = (
        'generator', 'is_generated',
        # is_hidden and is_cancelled aren't implemented yet,
        # so hiding relevant fields
        'is_hidden', 'is_cancelled', 'cancel_reason'
    )
    extra = 1
    readonly_fields = ('is_protected_from_regeneration', 'external_ref')


class EventChildAdmin(
    PolymorphicChildModelAdmin,
    icekit_admin.ICEkitContentsAdmin,
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
    ] + icekit_admin.ICEkitContentsAdmin.inlines
    raw_id_fields = ('part_of', )
    save_on_top = True
    filter_horizontal = ('secondary_types', )

    fieldsets = (
        (None, {
            'fields': (
                'title',
                'slug',
                'primary_type',
                'secondary_types',
                'part_of',
                'external_ref',
            ),
        }),
        ('Dates, times & tickets', {
            'description': "Use human dates and times if the automatically generated ones don't suit your needs.",
            'fields': (
                'show_in_calendar',
                'human_dates',
                'human_times',
                'is_drop_in',
                'has_tickets_available',
                'price_line',
            ),
        }),
        ('Content', {
            'fields': {
                'layout',
                'special_instructions',
                'cta_text',
                'cta_url',
            },
        }),
    )



class EventChildModelPlugin(six.with_metaclass(
    PluginMount, BaseChildModelPlugin)):
    """
    Mount point for ``EventBase`` child model plugins.
    """
    model_admin = EventChildAdmin


class EventTypeFilter(ChildModelFilter):
    child_model_plugin_class = EventChildModelPlugin


class PrimaryCategoryFilter(SimpleListFilter):
    title = "primary category"
    parameter_name = "primary_category"

    def lookups(self, request, model_admin):
        """
        Returns a list of tuples. The first element in each
        tuple is the coded value for the option that will
        appear in the URL query. The second element is the
        human-readable name for the option that will appear
        in the right sidebar.
        """

        types = models.EventType.objects.filter(is_public=True).order_by('slug')

        types = [(t.id, t.swatch()) for t in types]

        return types

    def queryset(self, request, queryset):
        if self.value():
            return queryset.filter(primary_type=self.value())
        return queryset


class EventAdmin(ChildModelPluginPolymorphicParentModelAdmin,
                 icekit_admin.ICEkitFluentContentsAdmin):
    """
    Polymorphic parent admin for Events.
    """
    base_model = models.EventBase
    list_filter = (
        EventTypeFilter, PrimaryCategoryFilter, 'secondary_types', 'modified', 'show_in_calendar', 'is_drop_in', 'has_tickets_available',
    ) + icekit_admin.ICEkitContentsAdmin.list_filter
    list_display = (
        'primary_type_swatch', 'publishing_object_title', 'child_type_name', 'modified',
        'publishing_column',
        'part_of_display', 'show_in_calendar', 'has_tickets_available', 'is_drop_in',
        'occurrence_count',
        'first_occurrence', 'last_occurrence',
        # ICEkit Workflow columns
        'last_edited_by_column', 'workflow_states_column',
    )
    list_display_links = ('primary_type_swatch', 'publishing_object_title', )
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

        # mutable copy
        request.GET = request.GET.copy()

        if 'timezone' in request.GET:
            tz = djtz.get(request.GET.pop('timezone'))
        else:
            tz = get_current_timezone()

        if 'start' in request.GET:
            start = djtz.localize(
                datetime.datetime.strptime(request.GET.pop('start')[0], '%Y-%m-%d'), tz)
        else:
            start = None
        if 'end' in request.GET:
            end = djtz.localize(
                datetime.datetime.strptime(request.GET.pop('end')[0], '%Y-%m-%d'), tz)
        else:
            end = None

        # filter the qs like the changelist filters
        cl = ChangeList(request, self.model, self.list_display,
                        self.list_display_links, self.list_filter,
                        self.date_hierarchy, self.search_fields,
                        self.list_select_related, self.list_per_page,
                        self.list_max_show_all, self.list_editable, self)

        filtered_event_ids = cl.get_queryset(request).values_list('id', flat=True)
        all_occurrences = models.Occurrence.objects.filter(event__id__in=filtered_event_ids).overlapping(start, end)

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

        if occurrence.event.primary_type:
            color = occurrence.event.primary_type.color
        else:
            color = "#cccccc"
        return {
            'title': title,
            'allDay': occurrence.is_all_day or occurrence.event.contained_events.exists(),
            'start': start,
            'end': end,
            'url': reverse('admin:icekit_events_eventbase_change',
                           args=[occurrence.event.pk]),
            'className': self._calendar_classes_for_occurrence(occurrence),
            'backgroundColor': color,
        }

    def _calendar_classes_for_occurrence(self, occurrence):
        """
        Return css classes to be used in admin calendar JSON
        """
        classes = [slugify(occurrence.event.polymorphic_ctype.name)]

        # Add a class name for the type of event.
        if occurrence.is_all_day:
            classes.append('is-all-day')
        if occurrence.is_protected_from_regeneration:
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

    def primary_type_swatch(self, obj):
        if obj.primary_type:
            return obj.primary_type.swatch(color_only=True)
        return None
    primary_type_swatch.short_description = u'⬤'
    primary_type_swatch.admin_order_field = 'primary_type'


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
    list_display = TitleSlugAdmin.list_display + ('color', 'is_public')
    list_filter = ('is_public',)
    list_editable = ('color', )


admin.site.register(models.EventBase, EventAdmin)
admin.site.register(models.EventType, EventTypeAdmin)
admin.site.register(models.RecurrenceRule, RecurrenceRuleAdmin)
