from fluent_contents.admin import PlaceholderEditorAdmin
from fluent_contents.models import PlaceholderData

from django.contrib import admin

from icekit.workflow.admin import WorkflowMixinAdmin, \
    WorkflowStateTabularInline

import logging

from django.conf import settings
from django.utils.translation import ugettext_lazy as _
from icekit.utils.attributes import resolve

logger = logging.getLogger(__name__)


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


class HeroMixinAdmin(admin.ModelAdmin):
    raw_id_fields = ('hero_image',)

    # Alas, we cannot use 'fieldsets' as it causes a recursionerror on
    # (polymorphic?) admins that use base_fieldsets.
    FIELDSETS = (
        ('Hero section', {
            'fields': (
                'hero_image',
            )
        }),
    )


class ListableMixinAdmin(admin.ModelAdmin):
    FIELDSETS = (
        ('Advanced listing options', {
            'classes': ('collapse',),
            'fields': (
                'list_image',
                'boosted_search_terms',
            )
        }),
    )


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


# import has to happen here to avoid circular import errors
from icekit.publishing.admin import PublishingAdmin, \
    PublishableFluentContentsAdmin


class ICEkitContentsAdmin(PublishingAdmin, WorkflowMixinAdmin):
    """
    A base for generic admins that will include ICEkit features:

     - publishing
     - workflow
    """
    list_display = PublishingAdmin.list_display + \
        WorkflowMixinAdmin.list_display
    list_filter = PublishingAdmin.list_filter + \
        WorkflowMixinAdmin.list_filter
    inlines = [WorkflowStateTabularInline]


class ICEkitFluentContentsAdmin(
        PublishableFluentContentsAdmin, WorkflowMixinAdmin):
    """
    A base for Fluent Contents admins that will include ICEkit features:

     - publishing
     - workflow
    """
    list_display = ICEkitContentsAdmin.list_display
    list_filter = ICEkitContentsAdmin.list_filter
    inlines = ICEkitContentsAdmin.inlines


class ThumbnailAdminMixin(object):
    """
    Shortcut for displaying a thumbnail in a changelist (or inline).

    Requires easy-thumbnails.

    Specify ImageField name in `thumbnail_field`, and optionally
    override `thumbnail_options` for customisation such as sizing,
    cropping, etc. If `thumbnail_show_exceptions` is truthy, exception
    messages are returned in place of a thumbnail on failure.

    Plays nicely with list_display_links if you want a click-able
    thumbnail.

    Add 'thumbnail' to `list_display` or `readonly_fields`, etc to
    display.
    """

    thumbnail_field = None # an attribute or callable on the object
    try:
        thumbnail_options = settings.THUMBNAIL_ALIASES['']['admin']
    except (KeyError, AttributeError):
        thumbnail_options = {'size': (150, 150),}
    thumbnail_show_exceptions = False

    def get_thumbnail_source(self, obj):
        """
        Obtains the source image field for the thumbnail.

        :param obj: An object with a thumbnail_field defined.
        :return: Image field for thumbnail or None if not found.
        """
        if hasattr(self, 'thumbnail_field') and self.thumbnail_field:
            return resolve(obj, self.thumbnail_field)

        # try get_list_image, from ListableMixin
        if hasattr(obj, 'get_list_image'):
            return resolve(obj, "get_list_image")

        logger.warning('ThumbnailAdminMixin.thumbnail_field unspecified')
        return None

    def thumbnail(self, obj):
        """
        Generate the HTML to display for the image.

        :param obj: An object with a thumbnail_field defined.
        :return: HTML for image display.
        """
        source = self.get_thumbnail_source(obj)
        if source:
            try:
                from easy_thumbnails.files import get_thumbnailer
            except ImportError:
                logger.warning(
                    _(
                        '`easy_thumbnails` is not installed and required for '
                        'icekit.utils.admin.mixins.ThumbnailAdminMixin'
                    )
                )
                return ''
            try:
                thumbnailer = get_thumbnailer(source)
                thumbnail = thumbnailer.get_thumbnail(self.thumbnail_options)
                return '<img class="thumbnail" src="{0}" />'.format(
                    thumbnail.url)
            except Exception as ex:
                logger.warning(
                    _(u'`easy_thumbnails` failed to generate a thumbnail image'
                      u' for {0}'.format(source)))
                if self.thumbnail_show_exceptions:
                    return 'Thumbnail exception: {0}'.format(ex)
        return ''
    thumbnail.allow_tags = True
