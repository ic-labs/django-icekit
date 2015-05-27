"""
Admin configuration for ``eventkit`` app.
"""

# Define `list_display`, `list_filter` and `search_fields` for each model.
# These go a long way to making the admin more usable.

import datetime
import json

from django.contrib import admin
from django.core.serializers.json import DjangoJSONEncoder
from django.core.urlresolvers import reverse
from django.http import HttpResponse
from django.template.response import TemplateResponse
from polymorphic.admin import \
    PolymorphicParentModelAdmin, PolymorphicChildModelAdmin
from timezone import timezone

from eventkit import models, settings


class EventChildAdmin(PolymorphicChildModelAdmin):
    base_model = models.Event


class EventAdmin(PolymorphicParentModelAdmin):
    base_model = models.Event
    list_filter = ('all_day', 'starts', 'ends')
    list_display = ('__unicode__', 'all_day', 'starts', 'ends')
    search_fields = ('title', )

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
                name='eventkit_event_calendar'
            ),
        )
        return my_urls + urls

    def calendar(self, request):
        """
        Return event data in JSON format for AJAX requests, or a calendar page
        to be loaded in an iframe.
        """
        if not request.is_ajax():
            return TemplateResponse(
                request, 'admin/eventkit/event/calendar.html')
        tz = timezone.get(request.GET.get('timezone'))
        starts = timezone.localize(
            datetime.datetime.strptime(request.GET['start'], '%Y-%m-%d'), tz)
        ends = timezone.localize(
            datetime.datetime.strptime(request.GET['end'], '%Y-%m-%d'), tz)
        events = self.base_model.objects \
            .filter(starts__gte=starts, starts__lt=ends) \
            .values_list(
                'id', 'original', 'title', 'all_day', 'starts', 'ends')
        data = []
        seen = []
        for pk, original, title, all_day, starts, ends in events:
            id_ = original or pk
            if id_ not in seen:
                seen.append(id_)
            # Get colors based on seen index for original event, so repeat
            # events have the same color as the original. Repeat colors when
            # all have been used.
            background, color = settings.CALENDAR_COLORS[
                seen.index(id_) % len(settings.CALENDAR_COLORS)]
            data.append({
                'id': id_,
                'title': title,
                'allDay': all_day,
                'start': timezone.localize(starts),
                'end': timezone.localize(ends),
                'url': reverse('admin:eventkit_event_change', args=[pk]),
                'color': background,
                'textColor': color,
            })
        data = json.dumps(data, cls=DjangoJSONEncoder)
        return HttpResponse(content=data, content_type='applicaton/json')

    def get_child_models(self):
        # TODO: Registration system for event plugins.
        return ()

admin.site.register(models.Event, EventAdmin)


class RecurrenceRuleAdmin(admin.ModelAdmin):
    model = models.RecurrenceRule

admin.site.register(models.RecurrenceRule, RecurrenceRuleAdmin)
