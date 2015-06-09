from django.contrib import admin
from django.template.loader import get_template
from fluent_contents.admin import PlaceholderEditorAdmin
from fluent_contents.analyzer import get_template_placeholder_data

from eventkit.admin import EventChildAdmin
from eventkit.plugins.fluentevent.models import FluentEvent


class FluentEventAdmin(EventChildAdmin, PlaceholderEditorAdmin):
    change_form_template = 'icekit/admin/fluent_layouts_change_form.html'
    model = FluentEvent

    class Media:
        js = ('icekit/admin/js/fluent_layouts.js', )

    def get_placeholder_data(self, request, obj):
        """
        Get placeholder data from layout.
        """
        if not obj:
            template = 'eventkit_fluentevent/layouts/default.html'
        else:
            template = obj.layout.template_name
        return get_template_placeholder_data(get_template(template))

admin.site.register(FluentEvent, FluentEventAdmin)
