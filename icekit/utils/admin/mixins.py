import logging
from django.utils.translation import ugettext_lazy as _
logger = logging.getLogger(__name__)


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

    thumbnail_field = None
    thumbnail_options = {
        'size': (100, 100),
    }
    thumbnail_show_exceptions = False

    def get_thumbnail_source(self, obj):
        """
        Obtains the source image field for the thumbnail.

        :param obj: An object with a thumbnail_field defined.
        :return: Image field for thumbnail or None if not found.
        """
        if hasattr(self, 'thumbnail_field') and self.thumbnail_field:
            return getattr(obj, self.thumbnail_field)

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
