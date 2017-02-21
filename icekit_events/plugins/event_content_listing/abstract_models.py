from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _

from icekit.plugins.content_listing.abstract_models import \
    AbstractContentListingItem


@python_2_unicode_compatible
class AbstractEventContentListingItem(AbstractContentListingItem):
    """
    An embedded listing of event content items.
    """

    class Meta:
        abstract = True
        verbose_name = _('Event Content Listing')

    def __str__(self):
        return 'Event Content Listing of %s' % self.content_type

    def get_items(self):
        return super(AbstractEventContentListingItem, self).get_items()
