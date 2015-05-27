from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class Image(models.Model):
    """
    A reusable image.
    """
    image = models.ImageField(
        upload_to='uploads/images/',
        verbose_name=_('Image field'),
    )
    alt_text = models.CharField(
        max_length=255,
        help_text=_("A description of the image for users who don't see images."),
    )
    title = models.CharField(
        max_length=255,
        blank=True,
        help_text=_('The title is shown in the caption.'),
    )
    caption = models.TextField(
        blank=True,
    )
    is_active = models.BooleanField(
        default=True,
    )
    categories = models.ManyToManyField(
        'icekit.MediaCategory',
        blank=True,
        related_name='%(app_label)s_%(class)s_related',
    )
    admin_notes = models.TextField(
        blank=True,
        help_text=_('Internal notes for administrators only.'),
    )

    def __str__(self):
        return str(self.alt_text)


@python_2_unicode_compatible
class ImageItem(ContentItem):
    """
    An image from the Image model.
    """
    image = models.ForeignKey(
        'Image',
        help_text=_('An image from the image library.')
    )

    class Meta:
        verbose_name = _('Reusable image')
        verbose_name_plural = _('Reusable images')

    def __str__(self):
        return str(self.image)
