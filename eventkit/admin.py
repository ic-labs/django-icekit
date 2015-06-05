"""
Admin configuration for ``eventkit`` app.
"""

# Define `list_display`, `list_filter` and `search_fields` for each model.
# These go a long way to making the admin more usable.

from dateutil import rrule
import datetime
import json
import six

from django.contrib import admin
from django.core.serializers.json import DjangoJSONEncoder
from django.core.urlresolvers import reverse
from django.http import HttpResponse, JsonResponse
from django.template.response import TemplateResponse
from django.utils.translation import ugettext_lazy as _
from django.views.decorators.csrf import csrf_exempt
from polymorphic.admin import \
    PolymorphicParentModelAdmin, PolymorphicChildModelAdmin
from timezone import timezone

from eventkit import admin_forms, appsettings, forms, models


class EventChildAdmin(PolymorphicChildModelAdmin):
    base_form = admin_forms.BaseEventForm
    base_model = models.Event
    formfield_overrides = {
        models.RecurrenceRuleField: {'widget': forms.RecurrenceRuleWidget},
    }

    def save_model(self, request, obj, form, change):
        """
        Propagate changes if requested.
        """
        obj.save(propagate=form.cleaned_data['propagate'])


class EventAdmin(PolymorphicParentModelAdmin):
    base_model = models.Event
    list_filter = ('all_day', 'starts', 'ends', 'is_repeat')
    list_display = ('__str__', 'all_day', 'starts', 'ends', 'is_repeat')
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
        events = self.get_queryset(request) \
            .filter(starts__gte=starts, starts__lt=ends) \
            .values_list(
                'id', 'parent', 'title', 'all_day', 'starts', 'ends',
                'is_repeat')
        data = []
        # Get the primary keys for all root and variation events into a list,
        # so we can assign them and their repeat events a consistent colour.
        seen = list(
            models.Event.objects
            .filter(is_repeat=False)
            .values_list('pk', flat=True)
            .order_by('pk'))
        for pk, parent, title, all_day, starts, ends, is_repeat in events:
            id_ = parent if is_repeat else pk
            if id_ not in seen:
                seen.append(id_)
            # Get color based on seen index for parent event, so its repeat
            # events have the same color. Start repeating colors when they have
            # all been used.
            background, color = appsettings.CALENDAR_COLORS[
                seen.index(id_) % len(appsettings.CALENDAR_COLORS)]
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
        child_models = [
            (models.Event, EventChildAdmin),
        ]
        return child_models

admin.site.register(models.Event, EventAdmin)


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
                name='eventkit_recurrencerule_preview'
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

admin.site.register(models.RecurrenceRule, RecurrenceRuleAdmin)
