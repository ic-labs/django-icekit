"""
Admin configuration for ``icekit`` app.
"""

# Define `list_display`, `list_filter` and `search_fields` for each model.
# These go a long way to making the admin more usable.

from django.conf.urls import url, patterns
from django.contrib import admin
from django.http import JsonResponse
from django.template.loader import get_template, select_template
from fluent_contents.admin import PlaceholderEditorAdmin
from fluent_contents.analyzer import get_template_placeholder_data
from polymorphic.admin import PolymorphicParentModelAdmin

from icekit import models


class FluentLayoutsMixin(PlaceholderEditorAdmin):
    """
    Mixin class for models that have a ``layout`` field and fluent content.
    """

    change_form_template = 'icekit/admin/fluent_layouts_change_form.html'

    class Media:
        js = ('icekit/admin/js/fluent_layouts.js', )

    def get_placeholder_data(self, request, obj):
        """
        Get placeholder data from layout.
        """
        if not obj or not obj.layout:
            meta = self.model._meta
            template = select_template([
                '{}/{}/layouts/default.html'.format(
                    meta.app_label, meta.model_name),
                '{}/layouts/default.html'.format(meta.app_label),
                'icekit/layouts/default.html',
            ])
        else:
            template = get_template(obj.layout.template_name)
        return get_template_placeholder_data(template)


class ChildModelPluginPolymorphicParentModelAdmin(PolymorphicParentModelAdmin):
    """
    Get child models and choice labels from registered plugins.
    """

    child_model_plugin_class = None
    child_model_admin = None

    def get_child_models(self):
        """
        Get child models from registered plugins. Fallback to the child model
        admin and its base model if no plugins are registered.
        """
        child_models = []
        for plugin in self.child_model_plugin_class.get_plugins():
            child_models.append((plugin.model, plugin.model_admin))
        if not child_models:
            child_models.append((
                self.child_model_admin.base_model,
                self.child_model_admin,
            ))
        return child_models

    def get_child_type_choices(self, request, action):
        """
        Override choice labels with ``verbose_name`` from plugins and sort.
        """
        # Get choices from the super class to check permissions.
        choices = super(ChildModelPluginPolymorphicParentModelAdmin, self) \
            .get_child_type_choices(request, action)
        # Update label with verbose name from plugins.
        plugins = self.child_model_plugin_class.get_plugins()
        labels = {
            plugin.content_type.pk: plugin.verbose_name for plugin in plugins
        }
        choices = [(ctype, labels[ctype]) for ctype, _ in choices]
        return sorted(choices, lambda a, b: cmp(a[1], b[1]))


class LayoutAdmin(admin.ModelAdmin):
    model = models.Layout

    def placeholder_data_view(self, request, id):
        """
        Return placeholder data for the given layout's template.
        """
        # See: `fluent_pages.pagetypes.fluentpage.admin.FluentPageAdmin`.
        try:
            layout = models.Layout.objects.get(pk=id)
        except models.Layout.DoesNotExist:
            json = {'success': False, 'error': 'Layout not found'}
            status = 404
        else:
            template = layout.get_template()
            placeholders = get_template_placeholder_data(template)

            status = 200
            json = {
                'id': layout.id,
                'key': layout.key,
                'title': layout.title,
                'placeholders': [p.as_dict() for p in placeholders],
            }

        return JsonResponse(json, status=status)

    def get_urls(self):
        """
        Add ``layout_placeholder_data`` URL.
        """
        # See: `fluent_pages.pagetypes.fluentpage.admin.FluentPageAdmin`.
        urls = super(LayoutAdmin, self).get_urls()
        my_urls = patterns(
            '',
            url(
                r'^placeholder_data/(?P<id>\d+)/$',
                self.admin_site.admin_view(self.placeholder_data_view),
                name='layout_placeholder_data',
            )
        )
        return my_urls + urls

admin.site.register(models.Layout, LayoutAdmin)


class MediaCategoryAdmin(admin.ModelAdmin):
    pass

admin.site.register(models.MediaCategory, MediaCategoryAdmin)
