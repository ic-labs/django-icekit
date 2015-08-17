from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class AbstractPageAnchorListItem(ContentItem):
    class Meta:
        abstract = True
        verbose_name = _('Page Anchor List')

    def __str__(self):
        return 'Page Anchor List'

    def get_anchors(self):
        return self.parent.contentitem_set.filter(pageanchoritem__anchor_name__isnull=False)
