from django.contrib import admin
from django.utils.text import capfirst

from fluent_contents.admin.contentitems import (BaseContentItemInline,
                                                get_content_item_inlines, )

# working around name clash
import importlib

from icekit.admin_tools.widgets import PolymorphicForeignKeyRawIdWidget, \
    PolymorphicManyToManyRawIdWidget
from icekit.workflow.admin import WorkflowMixinAdmin, WorkflowStateTabularInline


_pa = importlib.import_module("polymorphic.admin")
PolymorphicParentModelAdmin = _pa.PolymorphicParentModelAdmin

class PolymorphicAdminUtilsMixin(admin.ModelAdmin):
    """
    Utility methods for working with Polymorphic admins.
    """
    def child_type_name(self, inst):
        """
        e.g. for use in list_display
        :param inst: a polymorphic parent instance
        :return: The name of the polymorphic model
        """
        return capfirst(inst.polymorphic_ctype.name)
    child_type_name.short_description = "Type"


class ChildModelPluginPolymorphicParentModelAdmin(
    PolymorphicParentModelAdmin,
    PolymorphicAdminUtilsMixin
):
    """
    Get child models and choice labels from registered plugins.
    """

    child_model_plugin_class = None
    child_model_admin = None

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
                plugin.content_type.pk: capfirst(plugin.verbose_name) for plugin in plugins
            }
            choices = [(ctype, labels[ctype]) for ctype, _ in choices]
            return sorted(choices, lambda a, b: cmp(a[1], b[1]))
        return choices

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


# RAW_ID_FIELDS FIX ###########################################################


class PolymorphicAdminRawIdFix(object):
    """
    Use this mixin in any ModelAdmin that has a foreign key to a polymorphic
    model that you would like to be a raw id field.
    """

    def _get_child_admin_site(self, rel):
        """
        Returns the separate AdminSite instance that django-polymorphic
        maintains for child models.

        This admin site needs to be passed to the widget so that it passes the
        check of whether the field is pointing to a model that's registered
        in the admin.

        The hackiness of this implementation reflects the hackiness of the way
        django-polymorphic does things.
        """
        if rel.to not in self.admin_site._registry:
            # Go through the objects the model inherits from and find one
            # that's registered in the main admin and has a reference to the
            # child admin site in it attributes.
            for parent in rel.to.mro():
                if parent in self.admin_site._registry \
                and hasattr(self.admin_site._registry[parent], '_child_admin_site'):
                    return self.admin_site._registry[parent]._child_admin_site
        return self.admin_site

    def formfield_for_foreignkey(self, db_field, request=None, **kwargs):
        """
        Replicates the logic in ModelAdmin.forfield_for_foreignkey, replacing
        the widget with the patched one above, initialising it with the child
        admin site.
        """
        db = kwargs.get('using')
        if db_field.name in self.raw_id_fields:
            kwargs['widget'] = PolymorphicForeignKeyRawIdWidget(
                db_field.rel,
                admin_site=self._get_child_admin_site(db_field.rel),
                using=db
            )
            if 'queryset' not in kwargs:
                queryset = self.get_field_queryset(db, db_field, request)
                if queryset is not None:
                    kwargs['queryset'] = queryset
            return db_field.formfield(**kwargs)
        return super(PolymorphicAdminRawIdFix, self).formfield_for_foreignkey(
            db_field, request=request, **kwargs)

    def formfield_for_manytomany(self, db_field, request=None, **kwargs):
        """
        Replicates the logic in ModelAdmin.formfield_for_manytomany, replacing
        the widget with the patched one above, initialising it with the child
        admin site.
        """
        db = kwargs.get('using')
        if db_field.name in self.raw_id_fields:
            kwargs['widget'] = PolymorphicManyToManyRawIdWidget(
                db_field.rel,
                admin_site=self._get_child_admin_site(db_field.rel),
                using=db
            )
            kwargs['help_text'] = ''
            if 'queryset' not in kwargs:
                queryset = self.get_field_queryset(db, db_field, request)
                if queryset is not None:
                    kwargs['queryset'] = queryset
            return db_field.formfield(**kwargs)
        return super(PolymorphicAdminRawIdFix, self).formfield_for_manytomany(
            db_field, request=request, **kwargs)


class PolymorphicFluentAdminRawIdFix(PolymorphicAdminRawIdFix):
    """
    Use this mixin in any ModelAdmin for a Fluent content page to make sure
    that any Fluent inlines in the admin for the page inherit from the mixin
    above.

    Using this as the FLUENT_PAGES_[PARENT/CHILD]_ADMIN_MIXIN setting does not
    appear to work (possibly because of explicit model_admin declarations in
    PagePlugins defining page types).
    """

    def get_extra_inlines(self):
        # Replicates the equivalent method on PlaceholderEditorAdmin, except
        # adds the `base` kwarg to the inline generator, so that all inlines
        # have the polymorphic fix
        return [self.placeholder_inline] + \
            get_content_item_inlines(
                plugins=self.get_all_allowed_plugins(),
                base=PolymorphicReferringItemInline,
            )


class PolymorphicReferringItemInline(PolymorphicAdminRawIdFix, BaseContentItemInline):
    pass


# This import must go here to avoid class loading errors
from icekit.publishing.admin import ICEKitFluentPagesParentAdminMixin


# WARNING: Beware of very closely named classes here
class ICEkitFluentPagesParentAdmin(
        ICEKitFluentPagesParentAdminMixin, WorkflowMixinAdmin):
    """
    A base for Fluent Pages parent admins that will include ICEkit features:

     - publishing
     - workflow
    """
    # Go through contortions here to make sure the 'actions_column' is last
    list_display = [
        display_column for display_column in (
            ICEKitFluentPagesParentAdminMixin.list_display +
            WorkflowMixinAdmin.list_display)
        if display_column != 'actions_column'] + ['actions_column']
    list_filter = ICEKitFluentPagesParentAdminMixin.list_filter + \
        WorkflowMixinAdmin.list_filter
    inlines = [WorkflowStateTabularInline]
