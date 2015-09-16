from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class AbstractHorizontalRuleItem(ContentItem):
    class Meta:
        abstract = True
        verbose_name = _('Horizontal Rule')

    def __str__(self):
        return 'Horizontal Rule'
