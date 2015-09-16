from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class AbstractQuoteItem(ContentItem):
    """
    A one off quote.
    """
    quote = models.TextField()
    attribution = models.CharField(max_length=255, blank=True)

    class Meta:
        abstract = True
        verbose_name = _('Quote')
        verbose_name_plural = _('Quotes')

    def __str__(self):
        return self.quote
