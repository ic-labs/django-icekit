from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class HorizontalRuleItem(ContentItem):
    class Meta:
        verbose_name = _('Horizontal Rule')

    def __str__(self):
        return str('Horizontal Rule')
