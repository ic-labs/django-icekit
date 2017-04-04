# Admin for top-level ICEKit models
from django.conf import settings
from django.conf.urls import url, patterns
from django.contrib import admin
from django.contrib.contenttypes.models import ContentType
from django.http import JsonResponse

from icekit import models
from icekit.admin_tools.mixins import RawIdPreviewAdminMixin, \
    BetterDateTimeAdmin
from django.db.models import DateTimeField, DateField, TimeField


class LayoutAdmin(admin.ModelAdmin):
    filter_horizontal = ('content_types',)
    list_display = ('title', 'display_template_name', 'display_content_types' )

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

    def display_content_types(self, obj):
        return ", ".join([unicode(x) for x in obj.content_types.all()])

    def display_template_name(self, obj):
        return obj.template_name

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

            placeholders = [p.as_dict() for p in placeholders]

            # inject placeholder help text, if any is set
            for p in placeholders:
                try:
                    p['help_text'] = settings.FLUENT_CONTENTS_PLACEHOLDER_CONFIG.get(p['slot']).get('help_text')
                except AttributeError:
                    p['help_text'] = None

            json = {
                'id': layout.id,
                'title': layout.title,
                'placeholders': placeholders,
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

    def formfield_for_manytomany(self, db_field, request=None, **kwargs):
        if db_field.name == "content_types":
            kwargs["queryset"] = ContentType.objects.filter(pk__in=self._get_ctypes())

        return super(LayoutAdmin, self)\
            .formfield_for_manytomany(db_field, request, **kwargs)


class MediaCategoryAdmin(admin.ModelAdmin):
    pass


# import has to happen here to avoid circular import errors
from icekit.publishing.admin import PublishingAdmin, \
    PublishableFluentContentsAdmin
from icekit.workflow.admin import WorkflowMixinAdmin, WorkflowStateTabularInline


class ICEkitContentsAdmin(
    BetterDateTimeAdmin,
    PublishingAdmin,
    WorkflowMixinAdmin,
    RawIdPreviewAdminMixin,
):
    """
    A base for generic admins that will include ICEkit features:

     - publishing
     - workflow
     - Better date controls

    """
    list_display = PublishingAdmin.list_display + \
        WorkflowMixinAdmin.list_display
    list_filter = PublishingAdmin.list_filter + \
        WorkflowMixinAdmin.list_filter
    inlines = [WorkflowStateTabularInline]


class ICEkitFluentContentsAdmin(
    BetterDateTimeAdmin,
    PublishableFluentContentsAdmin,
    WorkflowMixinAdmin,
    RawIdPreviewAdminMixin,
):
    """
    A base for Fluent Contents admins that will include ICEkit features:

     - publishing
     - workflow
     - Better date controls

    """
    list_display = ICEkitContentsAdmin.list_display
    list_filter = ICEkitContentsAdmin.list_filter
    inlines = ICEkitContentsAdmin.inlines


class ICEkitInlineAdmin(BetterDateTimeAdmin):
    """
    A base for Inlines that will include ICEkit features:

    - Better date controls

    (we don't need RawIdPreview as the behaviour is injected into Inlines from
    the parent)
    """
    pass

admin.site.register(models.Layout, LayoutAdmin)
admin.site.register(models.MediaCategory, MediaCategoryAdmin)


# Token admin for Django REST framework's `TokenAuthentication`, see
# http://www.django-rest-framework.org/api-guide/authentication/#with-django-admin
from rest_framework.authtoken.admin import TokenAdmin
TokenAdmin.raw_id_fields = ('user',)


# Classes that used to be here

from icekit.admin_tools.filters import \
    ChildModelFilter as new_ChildModelFilter

from icekit.admin_tools.polymorphic import \
    PolymorphicAdminUtilsMixin as new_PolymorphicAdminUtilsMixin, \
    ChildModelPluginPolymorphicParentModelAdmin as new_ChildModelPluginPolymorphicParentModelAdmin

from icekit.utils.deprecation import deprecated

@deprecated
class ChildModelFilter(new_ChildModelFilter):
    """
    .. deprecated::
    Use :class:`icekit.admin_tools.filters.ChildModelFilter` instead.
    """
    pass


@deprecated
class PolymorphicAdminUtilsMixin(new_PolymorphicAdminUtilsMixin):
    """
    .. deprecated::
    Use :class:`icekit.admin_tools.polymorphic.PolymorphicAdminUtilsMixin` instead.
    """
    pass


@deprecated
class ChildModelPluginPolymorphicParentModelAdmin(new_ChildModelPluginPolymorphicParentModelAdmin):
    """
    .. deprecated::
    Use :class:`icekit.admin_tools.polymorphic.ChildModelPluginPolymorphicParentModelAdmin` instead.
    """
    pass

