from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from django.contrib.contenttypes.models import ContentType

from fluent_contents.models import ContentItem

from icekit.publishing.middleware import is_draft_request_context


@python_2_unicode_compatible
class AbstractContentListingItem(ContentItem):
    """
    An embedded listing of arbitrary content items.
    """
    content_type = models.ForeignKey(
        ContentType,
        help_text="Content type of items to show in a listing",
    )

    class Meta:
        abstract = True
        verbose_name = _('Content Listing')

    def __str__(self):
        return 'Content Listing of %s' % self.content_type

    def get_items(self):
        ModelClass = self.content_type.model_class()
        items_qs = ModelClass.objects.all()
        # Filter by published status
        if hasattr(items_qs, 'draft'):
            if is_draft_request_context():
                items_qs = items_qs.draft()
            else:
                items_qs = items_qs.published()
        # TODO Implement generally useful filters
        return items_qs
