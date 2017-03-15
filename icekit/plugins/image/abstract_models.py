# -*- coding: utf-8 -*-

from django.core.exceptions import ValidationError
from django.template import Context
from django.template.defaultfilters import filesizeformat
from django.template.loader import render_to_string
from django.utils import timezone
from django.utils.safestring import mark_safe
from django.db import models
from django.utils import six
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem
from icekit.fields import QuietImageField


@python_2_unicode_compatible
class AbstractImage(models.Model):
    """
    A reusable image.
    """
    image = QuietImageField(
        upload_to='uploads/images/',
        verbose_name=_('Image file'),
        width_field="width",
        height_field="height",
    )
    title = models.CharField(
        max_length=255,
        blank=True,
        help_text=_('You must specify either title or help text. Title can be included in captions.'),
    )
    alt_text = models.CharField(
        max_length=255,
        help_text=_(
            "A description of the image for users who don't see images "
            "visually. Leave blank if the image has no informational value."
        ),
        blank=True,
    )
    caption = models.TextField(
        blank=True,
    )
    credit = models.CharField(
        max_length=255,
        blank=True,
        help_text=_("Who or what to credit whenever the image is used."),
    )
    source = models.CharField(
        max_length=255,
        blank=True,
        help_text=_("Where this image came from."),
    )
    external_ref = models.CharField(
        max_length=255,
        blank=True,
        help_text=_("The reference for this image in a 3rd-party system"),
    )
    categories = models.ManyToManyField(
        'icekit.MediaCategory',
        blank=True,
        related_name='%(app_label)s_%(class)s_related',
    )
    license = models.TextField(
        _('License/rights information'),
        blank=True,
    )
    notes = models.TextField(
        blank=True,
        help_text=_('Internal notes for administrators only.'),
    )

    width = models.PositiveIntegerField(editable=False)
    height = models.PositiveIntegerField(editable=False)

    date_created = models.DateTimeField(
        default=timezone.now,
        editable=False
    )
    date_modified = models.DateTimeField(
        auto_now=True,
        editable=False
    )

    # Unused for now
    is_ok_for_web = models.BooleanField(
        _("OK for web"),
        default=True,
    )

    # Unused for now
    maximum_dimension_pixels = models.PositiveIntegerField(
        blank=True, null=True,
        help_text=_(
            "If this image is to be limited to a particular pixel size for "
            "distribution, note it here."
        ),
    )
    is_cropping_allowed = models.BooleanField(
        help_text="Can this image be cropped?",
        default=False
    )

    def clean(self):
        if not (self.title or self.alt_text):
            raise ValidationError("You must specify either title or alt text")

    class Meta:
        abstract = True

    def __str__(self):
        return self.title or self.alt_text

    def dimensions(self):
        if self.width and self.height:
            # NB using the multiplication symbol ×, not the letter x
            return u"%s × %s" % (self.width, self.heigh)
        return None

    def file_size(self):
        """
        Obtain the file size for the file in human readable format.

        :return: String of file size with unit.
        """
        return filesizeformat(self.image.size)



@python_2_unicode_compatible
class ImageLinkMixin(models.Model):
    """
    An image from the Image model.
    """
    image = models.ForeignKey(
        'icekit_plugins_image.Image',
        help_text=_('An image from the image library.'),
        on_delete=models.CASCADE,
    )

    show_title = models.BooleanField(default=False)
    show_caption = models.BooleanField(default=True)

    title_override = models.CharField(max_length=512, blank=True)
    caption_override = models.TextField(blank=True)
    # not allowing credit override yet

    caption_template = "icekit/plugins/image/_caption.html"

    class Meta:
        abstract = True

    def __str__(self):
        return six.text_type(self.image)

    @property
    def caption(self):
        """
        Obtains the caption override or the actual image caption.

        :return: Caption text (safe).
        """
        if self.show_caption:
            return mark_safe(self.caption_override or self.image.caption)
        return None

    @caption.setter
    def caption(self, value):
        """
        If the caption property is assigned, make it use the
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

    @property
    def title(self):
        """
        Obtains the title override or the actual image title.

        :return: Title text (safe).
        """
        if self.show_title:
            return mark_safe(self.title_override or self.image.title)
        return None

    @title.setter
    def title(self, value):
        """
        If the title property is assigned, make it use the
        `title_override` field.

        :param value: The title value to be saved.
        :return: None
        """
        self.title_override = value

    @title.deleter
    def title(self):
        """
        If the title property is to be deleted only delete the
        title override.

        :return: None
        """
        self.title_override = ''

    @property
    def credit(self):
        """
        :return: Image credit (safe).
        """
        return mark_safe(self.image.credit)

    def displayed_caption(self):
        c = Context({'instance': self})
        return render_to_string(self.caption_template, c)


@python_2_unicode_compatible
class AbstractImageItem(ContentItem, ImageLinkMixin):
    class Meta:
        abstract = True
        verbose_name = _('Image')
        verbose_name_plural = _('Images')

    def __str__(self):
        return six.text_type(self.image)
