from timezone import timezone

from django.db import models
from django.utils.translation import ugettext_lazy as _


class PublisherModelMixin(models.Model):
    """
    Model fields required to track publishing status. They can be added
    directly to models when possible, or monkey-patched into place via the
    `AppConfig` in this module.
    """
    publisher_linked = models.OneToOneField(
        'self',
        related_name='publisher_draft',
        null=True,
        editable=False,
        on_delete=models.SET_NULL)
    publisher_is_draft = models.BooleanField(
        default=True,
        editable=False,
        db_index=True)
    publisher_modified_at = models.DateTimeField(
        default=timezone.now,
        editable=False)
    publisher_published_at = models.DateTimeField(
        null=True, editable=False)

    # Publication start and end date fields from UrlNode
    publication_date = models.DateTimeField(
        _('publication date'), null=True, blank=True, db_index=True,
        help_text=_('''When the page should go live.'''))
    publication_end_date = models.DateTimeField(
        _('publication end date'), null=True, blank=True, db_index=True)

    class Meta:
        abstract = True
