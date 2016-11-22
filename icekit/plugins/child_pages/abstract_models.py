from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class AbstractChildPagesItem(ContentItem):
    class Meta:
        abstract = True
        verbose_name = _('Child Pages')

    def __str__(self):
        return 'Child Pages'

    def get_child_pages(self):
        # If my parent page is draft, show parent's (draft) children
        # if my parent page is published, show published equivalents of parent's children
        parent = self.parent

        if parent.is_draft:
            return [p for p in parent.get_children() if p.publishing_is_draft]
        else:
            return parent.get_draft().get_children().published()
