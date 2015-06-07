from django.contrib import admin
from django.template.loader import get_template
from fluent_contents.admin import PlaceholderEditorAdmin
from fluent_contents.analyzer import get_template_placeholder_data

from eventkit.admin import EventChildAdmin
from eventkit.plugins.fluentevent.models import FluentEvent


class FluentEventAdmin(EventChildAdmin, PlaceholderEditorAdmin):
    model = FluentEvent

    def get_placeholder_data(self, request, obj):
        """
        Get placeholder data from event template.
        """
        template = get_template('eventkit_fluentevent/default.html')
        return get_template_placeholder_data(template)

admin.site.register(FluentEvent, FluentEventAdmin)
