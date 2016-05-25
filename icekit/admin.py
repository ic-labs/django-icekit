"""
Admin configuration for ``icekit`` app.
"""

# Define `list_display`, `list_filter` and `search_fields` for each model.
# These go a long way to making the admin more usable.

from django.conf.urls import url, patterns
from django.contrib import admin
from django.contrib.contenttypes.models import ContentType
from django.http import JsonResponse
from django.utils.translation import ugettext_lazy as _
from fluent_contents.admin import PlaceholderEditorAdmin
from fluent_contents.analyzer import get_template_placeholder_data
from fluent_contents.models import PlaceholderData
from polymorphic.admin import PolymorphicParentModelAdmin

from icekit import models


# FILTERS #####################################################################


class ChildModelFilter(admin.SimpleListFilter):
    title = _('type')
    parameter_name = 'type'

    child_model_plugin_class = None

    def lookups(self, request, model_admin):
        lookups = [
            (p.content_type.pk, p.verbose_name.capitalize())
            for p in self.child_model_plugin_class.get_plugins()
        ]
        return lookups

    def queryset(self, request, queryset):
        value = self.value()
        if value:
            content_type = ContentType.objects.get_for_id(value)
            return queryset.filter(polymorphic_ctype=content_type)


# MIXINS ######################################################################


class FluentLayoutsMixin(PlaceholderEditorAdmin):
    """
    Mixin class for models that have a ``layout`` field and fluent content.
    """

    change_form_template = 'icekit/admin/fluent_layouts_change_form.html'

    class Media:
        js = ('icekit/admin/js/fluent_layouts.js', )

    def formfield_for_foreignkey(self, db_field, *args, **kwargs):
        """
        Update queryset for ``layout`` field.
        """
        formfield = super(FluentLayoutsMixin, self).formfield_for_foreignkey(
            db_field, *args, **kwargs)
        if db_field.name == 'layout':
            formfield.queryset = formfield.queryset.for_model(self.model)
        return formfield

    def get_placeholder_data(self, request, obj):
        """
        Get placeholder data from layout.
        """
        if not obj or not obj.layout:
            data = [PlaceholderData(slot='main', role='m', title='Main')]
        else:
            data = obj.layout.get_placeholder_data()
        return data


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
        if plugins:
            labels = {
                plugin.content_type.pk: plugin.verbose_name for plugin in plugins
            }
            choices = [(ctype, labels[ctype]) for ctype, _ in choices]
            return sorted(choices, lambda a, b: cmp(a[1], b[1]))
        return choices


# MODELS ######################################################################


class LayoutAdmin(admin.ModelAdmin):
    model = models.Layout

    def _get_ctypes(self):
        """
        Returns all related objects for this model.
        """
        ctypes = []
        for related_object in self.model._meta.get_all_related_objects():
            model = getattr(related_object, 'related_model', related_object.model)
            ctypes.append(ContentType.objects.get_for_model(model).pk)
            if model.__subclasses__():
                for child in model.__subclasses__():
                    ctypes.append(ContentType.objects.get_for_model(child).pk)
        return ctypes

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
            placeholders = layout.get_placeholder_data()

            status = 200
            json = {
                'id': layout.id,
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

    def get_form(self, *args, **kwargs):
        ctypes = self._get_ctypes()

        class Form(super(LayoutAdmin, self).get_form(*args, **kwargs)):
            def __init__(self, *args, **kwargs):
                super(Form, self).__init__(*args, **kwargs)
                self.fields['content_types'].queryset = self.fields[
                    'content_types'].queryset.filter(
                    pk__in=ctypes,
                )

        return Form


class MediaCategoryAdmin(admin.ModelAdmin):
    pass


admin.site.register(models.Layout, LayoutAdmin)
admin.site.register(models.MediaCategory, MediaCategoryAdmin)
