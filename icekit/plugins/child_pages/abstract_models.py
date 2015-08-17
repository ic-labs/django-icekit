from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class AbstractChildPageItem(ContentItem):
    class Meta:
        abstract = True
        verbose_name = _('Child Page')

    def __str__(self):
        return 'Child Pages'

    def get_child_pages(self):
        return self.parent.get_children()
