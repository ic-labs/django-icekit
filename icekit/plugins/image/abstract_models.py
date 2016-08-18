from django.utils.safestring import mark_safe
from django.db import models
from django.utils import six
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class AbstractImage(models.Model):
    """
    A reusable image.
    """
    image = models.ImageField(
        upload_to='uploads/images/',
        verbose_name=_('Image field'),
    )
    alt_text = models.CharField(
        max_length=255,
        help_text=_("A description of the image for users who don't see images"),
    )
    title = models.CharField(
        max_length=255,
        blank=True,
        help_text=_('The title is shown in the "title" attribute'),
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

    class Meta:
        abstract = True

    def __str__(self):
        return self.alt_text


@python_2_unicode_compatible
class AbstractImageItem(ContentItem):
    """
    An image from the Image model.
    """
    image = models.ForeignKey(
        'icekit_plugins_image.Image',
        help_text=_('An image from the image library.')
    )

    caption_override = models.TextField(blank=True)

    class Meta:
        abstract = True
        verbose_name = _('Image')
        verbose_name_plural = _('Images')

    def __str__(self):
        return six.text_type(self.image)

    @property
    def caption(self):
        """
        Obtains the caption override or the actual image caption.

        :return: Caption text (safe).
        """
        return mark_safe(self.caption_override or self.image.caption)

    @caption.setter
    def caption(self, value):
        """
        If the caption property is assigned to make it use the
        `caption_override` field.

        :param value: The caption value to be saved.
        :return: None
        """
        self.caption_override = value

    @caption.deleter
    def caption(self):
        """
        If the caption property is to be deleted only delete the
        caption override.

        :return: None
        """
        self.caption_override = ''
