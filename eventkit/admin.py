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
from django.db.models import Q
from django.http import HttpResponse, JsonResponse
from django.template.defaultfilters import slugify
from django.template.response import TemplateResponse
from django.utils.translation import ugettext_lazy as _
from django.views.decorators.csrf import csrf_exempt
from icekit.admin import (
    ChildModelFilter, ChildModelPluginPolymorphicParentModelAdmin)
from polymorphic.admin import PolymorphicChildModelAdmin
from timezone import timezone

from eventkit import admin_forms, appsettings, forms, models, plugins


class EventChildAdmin(PolymorphicChildModelAdmin):
    """
    Abstract admin class for polymorphic child event models.
    """
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


class EventTypeFilter(ChildModelFilter):
    child_model_plugin_class = plugins.EventChildModelPlugin


class OriginalFilter(admin.SimpleListFilter):
    title = _('is original')
    parameter_name = 'is_original'

    YES = '1'
    NO = '0'

    def lookups(self, request, model_admin):
        lookups = (
            (self.YES, _('Yes')),
            (self.NO, _('No')),
        )
        return lookups

    def queryset(self, request, queryset):
        if self.value() == self.YES:
            return queryset.filter(parent=None)
        elif self.value() == self.NO:
            return queryset.exclude(parent=None)


class VariationFilter(admin.SimpleListFilter):
    title = _('is variation')
    parameter_name = 'is_variation'

    YES = '1'
    NO = '0'

    def lookups(self, request, model_admin):
        lookups = (
            (self.YES, _('Yes')),
            (self.NO, _('No')),
        )
        return lookups

    def queryset(self, request, queryset):
        if self.value() == self.YES:
            return queryset.exclude(parent=None).exclude(is_repeat=True)
        elif self.value() == self.NO:
            return queryset.filter(Q(parent=None) | Q(is_repeat=True))


class EventAdmin(ChildModelPluginPolymorphicParentModelAdmin):
    base_model = models.Event
    list_filter = (
        'all_day', 'starts', 'ends', EventTypeFilter, OriginalFilter,
        VariationFilter, 'is_repeat', 'modified')
    list_display = (
        '__str__', 'all_day', 'starts', 'ends', 'is_original', 'is_variation',
        'is_repeat', 'modified')
    search_fields = ('title', )

    child_model_plugin_class = plugins.EventChildModelPlugin
    child_model_admin = EventChildAdmin

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
            context = {
                'is_popup': bool(int(request.GET.get('_popup', 0))),
            }
            return TemplateResponse(
                request, 'admin/eventkit/event/calendar.html', context)
        tz = timezone.get(request.GET.get('timezone'))
        starts = timezone.localize(
            datetime.datetime.strptime(request.GET['start'], '%Y-%m-%d'), tz)
        ends = timezone.localize(
            datetime.datetime.strptime(request.GET['end'], '%Y-%m-%d'), tz)
        events = self.get_queryset(request) \
            .filter(starts__gte=starts, starts__lt=ends) \
            .values_list(
                'pk', 'title', 'all_day', 'starts', 'ends', 'is_repeat',
                'tree_id', 'parent', 'polymorphic_ctype')
        data = []
        # Get a dict mapping the primary keys for content types to plugins, so
        # we can get the verbose name of the plugin and a consistent colour for
        # each event.
        plugins_for_ctype = {
            plugin.content_type.pk: plugin
            for plugin in plugins.EventChildModelPlugin.get_plugins()
        }
        # Get the keys into a sorted list, so we can assign a consistent colour
        # based on the index each event's content type is seen in the list.
        seen = sorted(plugins_for_ctype.keys())
        for (pk, title, all_day, starts, ends, is_repeat, tree_id, parent,
             polymorphic_ctype) in events:
            # Get color based on seen index for content type. Start repeating
            # colors when they have all been used.
            background, color = appsettings.CALENDAR_COLORS[
                seen.index(polymorphic_ctype) %
                len(appsettings.CALENDAR_COLORS)]
            # Slugify the plugin's verbose name for use as a class name.
            classes = [slugify(
                plugins_for_ctype[polymorphic_ctype].verbose_name)]
            # Add a class name for the type of event.
            if is_repeat:
                classes.append('is-repeat')
            elif not parent:
                classes.append('is-original')
            else:
                classes.append('is-variation')

            classes.append(tree_id);
            # Prefix class names with "fcc-" (full calander class).
            classes = ['fcc-%s' % class_ for class_ in classes]
            data.append({
                'id': tree_id,
                'title': title,
                'allDay': all_day,
                'start': timezone.localize(starts),
                'end': timezone.localize(ends),
                'url': reverse(
                    'admin:eventkit_event_change', args=[pk]),
                'className': classes,
                'color': background,
                'textColor': color,
            })
        data = json.dumps(data, cls=DjangoJSONEncoder)
        return HttpResponse(content=data, content_type='applicaton/json')

# Allow the option not to use the EventAdmin.
if appsettings.USE_EVENT_ADMIN:
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
