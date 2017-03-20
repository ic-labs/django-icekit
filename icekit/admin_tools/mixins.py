import warnings

from fluent_contents.admin import PlaceholderEditorAdmin
from fluent_contents.models import PlaceholderData
import logging

from icekit.admin_tools.previews import RawIdPreviewAdminMixin
from icekit.admin_tools.utils import admin_link
from icekit.utils.attributes import resolve

from django.utils.translation import ugettext_lazy as _
from django.conf import settings
from django.contrib import admin
try:
    import json
except ImportError:
    from django.utils import simplejson as json

logger = logging.getLogger(__name__)


class FluentLayoutsMixin(PlaceholderEditorAdmin, RawIdPreviewAdminMixin):
    """
    Mixin class for models that have a ``layout`` field and fluent content.
    """

    change_form_template = 'admin/fluent_layouts_change_form.html'

    class Media:
        js = ('admin/js/fluent_layouts.js', )

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
        if not obj or not getattr(obj, 'layout', None):
            data = [PlaceholderData(slot='main', role='m', title='Main')]
        else:
            data = obj.layout.get_placeholder_data()
        return data


class HeroMixinAdmin(RawIdPreviewAdminMixin):
    raw_id_fields = ('hero_image',)
    preview_fields = ('hero_image',)

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
                'list_image', # a filefield
                'boosted_search_terms',
            )
        }),
    )


class PreviewAdminMixin(object):
    """
    Shortcut for displaying a preview in a changelist (or inline).

    Override `preview` to control how the preview shows.

    Plays nicely with list_display_links and admin_link if you want a click-able
    preview.

    Add `'preview'` to `list_display` or `readonly_fields`, etc to
    display.
    """

    def preview(self, obj, request=None):
        if hasattr(obj, 'preview'):
            return obj.preview(request)
        else:
            return unicode(obj)
        admin_preview.allow_tags = True

    def admin_preview_link(self, obj, request=None):
        return admin_link(obj, inner_html=self.preview(obj, request))

    # TODO: this doesn't seem to run (maybe needs to extend modeladmin?)
    # def get_list_display_links(self):
    #     # avoid needing to add 'preview' to list_display_links
    #     default = set( super(PreviewAdminMixin, self).get_list_display_links() )
    #     default.add('preview')
    #     return list(default)


class ThumbnailAdminMixin(PreviewAdminMixin):
    """
    Shortcut for displaying a thumbnail in a changelist (or inline).

    Requires easy-thumbnails.

    Specify ImageField name in `thumbnail_field`, and optionally
    override `thumbnail_options` for customisation such as sizing,
    cropping, etc. If `thumbnail_show_exceptions` is truthy, exception
    messages are returned in place of a thumbnail on failure.
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

    def preview(self, obj, request=None):
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
    preview.allow_tags = True

    def thumbnail(self, *args, **kwargs):
        warnings.warn(
            "Use of 'thumbnail' for showing previews in ThumbnailAdminMixin is "
            "deprecated. Use `preview` instead",
            DeprecationWarning,
            stacklevel=2
        )
        return self.preview(*args, **kwargs)
    thumbnail.allow_tags = True

