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
    limit = models.IntegerField(
        blank=True, null=True,
        help_text="How many items to show? No limit is applied if this"
                  " field is not set"
    )

    class Meta:
        abstract = True
        verbose_name = _('Content Listing')

    def __str__(self):
        return 'Content Listing of %s' % self.content_type

    def get_items(self, apply_limit=True):
        """
        Return the items to show in the listing.

        If you override this method in a subclass but still call this method
        via `super` be sure to pass ``apply_limit=False`` when calling the
        method to avoid applying the count limit too early, then apply it
        yourself at the end of the override method like this:

            if self.limit:
                qs = qs[:self.limit]
        """
        model_class = self.content_type.model_class()
        if not model_class:
            return []
        items_qs = model_class.objects.all()
        # Filter by published status
        if hasattr(items_qs, 'draft'):
            if is_draft_request_context():
                items_qs = items_qs.draft()
            else:
                items_qs = items_qs.published()
        if apply_limit and self.limit:
            items_qs = items_qs[:self.limit]
        # TODO Implement generally useful filters
        return items_qs
