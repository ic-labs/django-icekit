import json
from urlparse import urlparse
from django.db import models
from django.db.models.query import QuerySet
from django.utils.encoding import python_2_unicode_compatible
from django.utils.safestring import mark_safe
from glamkit_collections.contrib.work_creator.fields import QuietImageField
from glamkit_collections.contrib.work_creator import settings
import colorweave
import webcolors


ARTWORK_IMAGE_COLORS = (
    ('maroon', '#800000'),
    ('red', '#ff0000'),
    ('orange', '#ffa500'),
    ('gold', '#ffd700'),
    ('deepskyblue', '#00b'),
    ('yellowgreen', '#9acd32'),
    ('mediumseagreen', '#3cb371'),
    ('deepskyblue', '#00bfff'),
    ('darkblue', '#00008b'),
    ('purple', '#800080'),
    ('black', '#000000'),
    ('darkslategrey', '#2f4f4f'),
    ('silver', '#c0c0c0'),
    ('white', '#ffffff'),
)


@python_2_unicode_compatible
class WorkImageViewBase(models.Model):
    """
    E.g. verso, detail, condition, etc. Images will be sorted by priority.
    """
    name = models.CharField(max_length=255, unique=True)
    priority = models.IntegerField(blank=True, null=True)

    class Meta:
        abstract = True
        ordering = ('priority', 'name', )

    def __str__(self):
        return self.name


class ArtworkImageQuerySet(QuerySet):
    def order_by_view(self):
        """
        Order the queryset by section, max view priority, order, creation_datetime, and name.
        """
        queryset = self \
            .annotate(view_priority=models.Min('views__priority')) \
            .order_by(
                'artwork',
                'view_priority',
                'order',
                'creation_datetime',
                '-netx_name',
                'pk',  # Always sort by a unique field for consistent results.
            )
        return queryset


class WorkImageBase(models.Model):

    artwork = models.ForeignKey('collection.Artwork', related_name='images', on_delete=models.PROTECT)

    order = models.PositiveIntegerField(null=True, blank=True)

    downloaded_image = QuietImageField(
        upload_to=settings.WORK_IMAGE_PATH,
        width_field='width',
        height_field='height',
    )
    height = models.IntegerField(null=True, blank=True)
    width = models.IntegerField(null=True, blank=True)

    creation_datetime = models.DateTimeField()
    modification_datetime = models.DateTimeField()
    retrieved_datetime = models.DateTimeField(auto_now=True)

    credit_line = models.TextField(
        blank=True,
    )

    caption_override = models.TextField(
        blank=True,
    )

    zoom_images_folder = models.CharField(max_length=255, blank=True, help_text="The folder, relative to the Media Root, where the zoom tiles are stored, if generated.")

    is_public = models.BooleanField(default=True)

    views = models.ManyToManyField('collection.ArtworkImageView', blank=True)

    # The dominant colours in image. A JSON field mapping hex colors to css3 colors. The css3 colors are
    # indexed in the search engine; the hex colors are shown. Don't access directly, access via get_colors().
    _colors = models.TextField(blank=True)

    objects = ArtworkImageQuerySet.as_manager()

    class Meta:
        ordering = ('artwork', 'order',)
        abstract = True
        permissions = (
            ("access_hires_image_files", "Can access hi-res image files"),
        )

    def __unicode__(self):
        return self.netx_name or self.netx_file_name or None

    def save(self, *args, **kwargs):
        """
        If kwarg ``extract_colors=True`` then extract image colors before save.
        Color extraction is disabled by default because it can be an expensive
        operation, especially if the image asset is stored remotely (e.g. S3).
        """
        if 'extract_colors' in kwargs:
            if kwargs['extract_colors']:
                self.extract_colors(save=False)
            del kwargs['extract_colors']

        super(WorkImageBase, self).save(*args, **kwargs)

    @property
    def views_display(self):
        return ",".join([v.name for v in self.views.all()])

    def max_size(self):
        return (self.width, self.height)

    def is_hero_image(self):
        return self.artwork.hero_image == self

    def caption(self):
        """
        Artists, name and year, followed by caption remainder.
        """
        if self.caption_override:
            return mark_safe(self.caption_override)
        result = u"%s, " % self.artwork.artists_text()
        result += self.artwork.title_html()
        views = self.views.values_list('name', flat=True)
        if 'primary view' in views:
            if 'detail' in views:
                result += u" (detail)"
            if 'still' in views:
                result += u" (still)"
        if self.artwork.date_display:
            result += u", " + self.artwork.date_display
        result += u"; "

        result += self.caption_remainder()

        return mark_safe(result)

    def caption_remainder(self):
        # The part of the caption after the Artists, Name and Year (and without the semicolon)
        result = ""
        if self.artwork.medium_display:
            result += self.artwork.medium_display + u", "
        if self.artwork.dimensions_display:
            result += self.artwork.dimensions_display + u"; "

        result += self.artwork.credit_display(separator=', ')

        if self.artwork.copyright:
            result += u"; " + self.artwork.copyright

        return mark_safe(result)

    def extract_colors(self, replace=True, save=True):
        """
        Extract dominant colors for this image's ``downloaded_image`` (if
        available) and store in ``_colors`` attribute.

        If the kwarg ``replace`` is ``True`` (the default) an image that
        already has extracted colors will have those colors re-extracted, else
        the existing colors will be left unchanged.

        If the kwarg ``save`` is ``True`` (the default) this item will be saved
        when colors are extracted, else it is up to the caller to ``save``.
        """
        # Do nothing if image is still available and has extracted colors and
        # ``replace`` isn't set
        if self._colors and self.downloaded_image and not replace:
            return

        if not self.downloaded_image:
            # We have no downloaded image, clear extracted colors
            self._colors = ''
        else:
            kwargs = {
                'format': None,
                'mode': 'kmeans'
            }

            # Are the assets stored or served from another host?
            if urlparse(self.downloaded_image.url).netloc:
                kwargs['url'] = self.downloaded_image.url
            else:
                kwargs['path'] = self.downloaded_image.path

            try:
                palette = colorweave.palette(**kwargs)
            except Exception as e:
                print(
                    'Error extracting colors from ArtworkImage [pk: {}]'
                    '\n\nError: {}\n\n'.format(self.pk, e)
                )
                palette = None

            if palette:
                closest_colors = {}
                for hex_color in palette:
                    closest_colors[hex_color] = get_closest_color(hex_color)
                self._colors = json.dumps(closest_colors)
            else:
                # We have empty/invalid palette data, clear extracted colors
                self._colors = ''

        if save:
            self.save()

    def get_colors(self, extract_colors=False):
        """
        Return dominant colors for this image's ``downloaded_image``.

        If an image has no extracted colors and the kwarg ``extract_colors`` is
        ``False`` (the default) return ``{}``, else this method will call the
        ``extract_colors`` method to try and extract and save the colors.
        """
        if not self._colors and extract_colors:
            self.extract_colors()

        if self._colors:
            return json.loads(self._colors).items()
        else:
            return []


def get_closest_color(hex_color):
    rgb_color = colorweave.hex_to_rgb(hex_color)
    min_colors = {}
    for name, hex in ARTWORK_IMAGE_COLORS:
        r_c, g_c, b_c = webcolors.hex_to_rgb(hex)
        rd = (r_c - rgb_color[0]) ** 2
        gd = (g_c - rgb_color[1]) ** 2
        bd = (b_c - rgb_color[2]) ** 2
        min_colors[(rd + gd + bd)] = name
    return min_colors[min(min_colors.keys())]
