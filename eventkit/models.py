"""
Models for ``eventkit`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.

from datetime import datetime, timedelta

from croniter import croniter
from django.db import models
from django.utils import timezone
from polymorphic import PolymorphicModel

from eventkit.utils import time

# New events will have a default `starts` value that is rounded up to a time
# matching this precision.
DEFAULT_STARTS_PRECISION = timedelta(hours=1)

# New events will have a default `ends` value that is this much later than
# their `starts` value.
DEFAULT_ENDS_DELTA = timedelta(hours=1)

# Repeat events that start later than this far in the future will not be
# created until a later date.
REPEAT_LIMIT = timedelta(weeks=13)


def default_starts():
    when = time.round_datetime(
        when=timezone.now(),
        precision=DEFAULT_STARTS_PRECISION,
        rounding=time.ROUND_UP,
    )
    return when


def default_ends():
    return default_starts() + DEFAULT_ENDS_DELTA


# MODELS ######################################################################


class AbstractBaseModel(models.Model):
    """
    Abstract base model with common fields and methods for all models.

    Add ``created`` and ``modified`` timestamp fields. Update the ``modified``
    field automatically on save. Sort by primary key.
    """

    created = models.DateTimeField(
        default=timezone.now, db_index=True, editable=False)
    modified = models.DateTimeField(
        default=timezone.now, db_index=True, editable=False)

    class Meta:
        abstract = True
        get_latest_by = 'pk'
        ordering = ('-id', )

    def save(self, *args, **kwargs):
        """
        Update ``self.modified``.
        """
        self.modified = timezone.now()
        super(AbstractBaseModel, self).save(*args, **kwargs)


class AbstractEvent(PolymorphicModel, AbstractBaseModel):
    """
    Abstract polymorphic event model, with the bare minimum fields.
    """

    # These fields will be copied when creating and updating repeat events.
    REPEAT_FIELDS = (
        'title',
        'all_day',
        'repeat_expression',
        'end_repeat',
    )

    original = models.ForeignKey('self', editable=False, null=True)
    title = models.CharField(max_length=255)
    all_day = models.BooleanField(default=False)
    starts = models.DateTimeField(default=default_starts)
    ends = models.DateTimeField(default=default_ends)
    repeat_expression = models.CharField(
        help_text='A cron expression that defines when this event repeats.',
        max_length=255,
    )
    end_repeat = models.DateTimeField(
        help_text='If empty, this event will repeat indefinitely.',
        null=True,
    )

    class Meta:
        abstract = True
        unique_together = ('starts', 'original')

    def create_repeat_events(self):
        """
        Create repeat events. This does not create a new distinct set of
        events or modify any existing events. New events will have the same
        original as this event.
        """
        assert self.pk, 'Cannot create repeat events before an event is saved.'
        original = self.original or self
        defaults = {
            field: getattr(self, field) for field in self.REPEAT_FIELDS
        }
        for starts in self.get_repeat_occurrences():
            defaults['ends'] = starts + self.duration
            type(self).objects.get_or_create(
                original=original, starts=starts, defaults=defaults
            )

    @property
    def duration(self):
        """
        Return the duration between ``starts`` and ``ends`` as a timedelta.
        """
        return self.ends - self.starts

    def get_repeat_occurrences(self):
        """
        Return an iterator of datetime objects for occurrences as specified in
        ``repeat_expression``.
        """
        assert self.repeat_expression, (
            'Cannot get repeat occurrences without a repeat expression.')
        end_repeat = self.end_repeat or timezone.now() + REPEAT_LIMIT
        items = croniter(self.repeat_expression, self.starts)
        while True:
            starts = items.get_next(datetime)
            if starts > end_repeat:
                break
            yield starts

    def update_future_events(self):
        """
        Update future events to match this event. This creates a new set of
        events with this event as their original.
        """
        assert self.pk, 'Cannot update future events before an event is saved.'
        # Use `self.original` (if defined) when fetching existing events to
        # update, and `self` when updating or creating new events.
        original = self.original or self
        # Get an iterator of existing events, so we can get the next event
        # while iterating repeat occurrences.
        existing_events = type(self).objects \
            .select_for_update() \
            .filter(original=original, pk__gt=self.pk) \
            .order_by('pk') \
            .iterator()
        # Iterate repeat occurrences, update existing future events first, then
        # create new events.
        defaults = {
            field: getattr(self, field) for field in self.REPEAT_FIELDS
        }
        for starts in self.get_repeat_occurrences():
            defaults['ends'] = starts + self.duration
            try:
                event = existing_events.next()
            except StopIteration:
                # No more to update. Create a new event.
                type(self).objects.create(original=self, **defaults)
            else:
                # Update existing event.
                event.original = self
                for field, value in defaults.iteritems():
                    setattr(event, field, value)
                event.save()
        # Delete any additional existing events that were not updated.
        for event in existing_events:
            event.delete()
        # Now that this event is itself a new original with its own set of
        # repeat events, decouple it from its old original.
        self.original = None
        self.save()


class Event(AbstractEvent):
    pass
