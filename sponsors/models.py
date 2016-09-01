"""
Sponsor type model declarations.
"""
from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from sfmoma import validators


@python_2_unicode_compatible
class Sponsor(models.Model):
    """
    Definition of a `Sponsor`.
    """
    name = models.CharField(max_length=255)
    logo = models.ForeignKey('image.Image')
    url = models.CharField(
        max_length=255,
        verbose_name='URL',
        blank=True,
        help_text=_(
            'It must start with `http://`, `https://` or be a relative URL starting with `/`'
        ),
        validators=[validators.RelativeURLValidator(), ]
    )

    def __str__(self):
        return self.name

