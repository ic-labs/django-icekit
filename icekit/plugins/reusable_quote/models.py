from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class Quote(models.Model):
    """
    A reusable quote.
    """
    quote = models.TextField()
    attribution = models.CharField(max_length=255, blank=True)

    def __str__(self):
        return str(self.quote)


@python_2_unicode_compatible
class ReusableQuoteItem(ContentItem):
    """
    A quote from the Quote model.
    """
    quote = models.ForeignKey(
        'Quote',
        help_text=_('An quote from the quote library.')
    )

    class Meta:
        verbose_name = _('Quote')
        verbose_name_plural = _('Quotes')

    def __str__(self):
        return str(self.quote)
