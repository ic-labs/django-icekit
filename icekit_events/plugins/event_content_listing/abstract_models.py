from datetime import timedelta

from django.db import models
from django.db.models import Q
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _

from timezone import timezone as djtz  # django-timezone

from icekit_events.models import EventType
from icekit.plugins.content_listing.abstract_models import \
    AbstractContentListingItem


@python_2_unicode_compatible
class AbstractEventContentListingItem(AbstractContentListingItem):
    """
    An embedded listing of event content items.
    """
    limit_to_types = models.ManyToManyField(
        EventType,
        help_text="Leave empty to show all events.",
        blank=True,
        db_table="ik_event_listing_types",
    )
    from_date = models.DateTimeField(
        blank=True, null=True,
        help_text="Only show events with occurrences that end after this"
                  " date and time.",
    )
    to_date = models.DateTimeField(
        blank=True, null=True,
        help_text="Only show events with occurrences that start before this"
                  " date and time.",
    )
    from_days_ago = models.IntegerField(
        blank=True, null=True,
        help_text="Only show events with occurrences after this number of"
                  " days into the past. Set this to zero to show only events"
                  " with future occurrences.",
    )
    to_days_ahead = models.IntegerField(
        blank=True, null=True,
        help_text="Only show events with occurrences before this number of"
                  " days into the future. Set this to zero to show only events"
                  " with past occurrences.",
    )

    class Meta:
        abstract = True
        verbose_name = _('Event Content Listing')

    def __str__(self):
        return 'Event Content Listing of %s' % self.content_type

    def get_items(self):
        qs = super(AbstractEventContentListingItem, self).get_items(
            apply_limit=False)
        if self.limit_to_types.count():
            types = self.limit_to_types.all()
            qs = qs.filter(
                Q(primary_type__in=types) |
                Q(secondary_types__in=types)
            )
        # Apply `from_date` and `to_date` limits
        qs = qs.overlapping(self.from_date, self.to_date)
        # Apply `from_days_ago` and `to_days_ahead` limits
        today = djtz.now().date()
        from_date = to_date = None
        if self.from_days_ago is not None:
            from_date = today - timedelta(days=self.from_days_ago)
        if self.to_days_ahead is not None:
            to_date = today + timedelta(days=self.to_days_ahead)
        qs = qs.overlapping(from_date, to_date)
        # Apply a sensible default ordering
        qs = qs.order_by_first_occurrence()
        if self.limit:
            qs = qs[:self.limit]
        return qs
