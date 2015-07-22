from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class FAQItem(ContentItem):
    """
    A one off FAQ.
    """
    question = models.TextField()
    answer = models.TextField()
    load_open = models.BooleanField(default=False)

    class Meta:
        verbose_name = _('FAQ')
        verbose_name_plural = _('FAQs')

    def __str__(self):
        return str(self.question)
