"""
Sponsor type model declarations.
"""
from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem

from icekit.validators import RelativeURLValidator


@python_2_unicode_compatible
class Sponsor(models.Model):
    """
    Definition of a `Sponsor`.
    """
    name = models.CharField(max_length=255)
    logo = models.ForeignKey('icekit_plugins_image.Image')
    url = models.CharField(
        max_length=255,
        verbose_name='URL',
        blank=True,
        help_text=_(
            'It must start with `http://`, `https://` or be a relative URL starting with `/`'
        ),
        validators=[RelativeURLValidator(), ]
    )

    def __str__(self):
        return self.name


@python_2_unicode_compatible
class BeginSponsorBlockItem(ContentItem):
    text = models.TextField(blank=True, help_text="HTML is allowed")

    def __str__(self):
        return "Begin sponsor block"

    class Meta:
        verbose_name = _('Begin Sponsor Block')


@python_2_unicode_compatible
class EndSponsorBlockItem(ContentItem):
    text = models.TextField(blank=True, help_text="HTML is allowed")

    def __str__(self):
        return "End sponsor block"

    class Meta:
        verbose_name = _('End sponsor block')


@python_2_unicode_compatible
class SponsorPromoItem(ContentItem):
    """
    Promotional item for a sponsor.
    """
    sponsor = models.ForeignKey('glamkit_sponsors.Sponsor')
    title = models.CharField(
        max_length=120,
        blank=True,
        help_text=_(
            'An optional title that will appear at the top of the sponsor '
            'logo e.g. Presenting Sponsor.'
        )
    )
    width = models.IntegerField(
        default=200,
        help_text="The width to show the sponsor logo, default 200px",
    )
    quality = models.IntegerField(
        default=85,
        help_text="The JPEG quality to use for the sponsor logo, default 85%",
    )

    class Meta:
        verbose_name = _('Sponsor promo')

    def __str__(self):
        return unicode(self.sponsor)

    def dimensions(self):
        return "%sx0" % self.width
