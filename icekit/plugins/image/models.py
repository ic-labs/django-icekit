from urlparse import urljoin

from icekit.content_collections.abstract_models import TitleSlugMixin
from icekit.fields import ICEkitURLField
from icekit.plugins.iiif.utils import SUPPORTED_EXTENSIONS
from icekit.plugins.iiif.utils import SUPPORTED_QUALITY
from django.db import models

from . import abstract_models


FORMAT_CHOICES = [(x, x) for x in SUPPORTED_EXTENSIONS]
QUALITY_CHOICES = [(x, x) for x in SUPPORTED_QUALITY]

class Image(abstract_models.AbstractImage):
    """
    A reusable image.
    """
    pass


class ImageItem(abstract_models.AbstractImageItem):
    """
    An image from the Image model.
    """
    carousel_cta_url = ICEkitURLField(
        "Carousel CTA URL",
        blank=True,
        null=True,
    )
    carousel_cta_text_label = models.CharField(
        "Carousel CTA Text Label",
        max_length=255,
        blank=True,
    )


class ImageRepurposeConfig(TitleSlugMixin):
    """
    A configuration for an IIIF rendering of an image.

    For now, we only need scale width x height.
    """

    # TODO: cropping is likely to be more complicated, as it depends somewhat
    # on the original size of the file.

    width = models.PositiveIntegerField(blank=True, null=True)
    height = models.PositiveIntegerField(blank=True, null=True)
    is_cropping_allowed = models.BooleanField(help_text="Can we crop the image to be exactly width x height?", default=False)
    format = models.CharField(max_length=4, choices=FORMAT_CHOICES, default=FORMAT_CHOICES[0][0])
    style = models.CharField(max_length=16, choices=QUALITY_CHOICES, default=QUALITY_CHOICES[0][0])

    def size_spec(self):
        if not (self.width or self.height):
            return "max"
        size = "%(width)s,%(height)s" % {
            'width': self.width or "",
            'height': self.height or "",
        }
        if not self.is_cropping_allowed:
            size = "!"+size
        return size

    def iiif_url(self):
        return "/full/%(size)s/0/%(style)s.%(format)s" % {
            'size': self.size_spec(),
            'style': self.style,
            'format': self.format,
        }

    def __unicode__(self):
        return "%s (%s)" % (self.title, self.iiif_url())

    def url_for_image(self, image):
        return "/iiif/%(id)s%(url)s" % {
            'id': image.pk,
            'url': self.iiif_url(),
        }

    class Meta:
        verbose_name = "Image derivative"
