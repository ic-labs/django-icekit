"""
Models for ``eventkit`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.

from datetime import timedelta
from dateutil.rrule import rrulestr
import six

from django.db import models, transaction
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
    repeat_expression = models.TextField(
        help_text='An RFC2445 expression that defines when this event '
                  'repeats.',
        max_length=255,
        null=True,
    )
    end_repeat = models.DateTimeField(
        help_text='If empty, this event will repeat indefinitely.',
        null=True,
    )

    class Meta:
        abstract = True
        unique_together = ('starts', 'original')

    def __init__(self, *args, **kwargs):
        """
        Store repeat field values.
        """
        super(AbstractEvent, self).__init__(*args, **kwargs)
        self._store_repeat_fields()

    def _repeat_fields_changed(self, fields=None):
        """
        Return ``True`` if the given field (or any field, if None) has changed.
        """
        fields = fields or self.REPEAT_FIELDS
        if isinstance(fields, six.text_type):
            fields = [fields]
        for field in fields:
            if getattr(self, field) != self._repeat_fields[field]:
                return True
        return False

    def _store_repeat_fields(self):
        """
        Store repeat values so we can detect and propagate changes.
        """
        self._repeat_fields = {
            k: getattr(self, k) for k in self.REPEAT_FIELDS
        }

    def create_repeat_events(self):
        """
        Create missing repeat events according to the repeat expression, up
        until the configured limit.
        """
        assert self.pk, 'Cannot create repeat events before an event is saved.'
        rruleset = self.get_rruleset()
        # Exclude existing events.
        rruleset.exdate(self.starts)
        existing = self \
            .get_repeat_events() \
            .values_list('starts', flat=True)
        for starts in existing:
            rruleset.exdate(starts)
        # Create missing events, up until the configured limit.
        end_repeat = timezone.now() + REPEAT_LIMIT
        original = self.original or self
        defaults = {
            field: getattr(self, field) for field in self.REPEAT_FIELDS
        }
        for starts in rruleset:
            if starts > end_repeat:
                break
            ends = starts + self.duration
            event = type(self)(
                original=original, starts=starts, ends=ends, **defaults)
            super(AbstractEvent, event).save()  # Bypass automatic propagation.

    @property
    def duration(self):
        """
        Return the duration between ``starts`` and ``ends`` as a timedelta.
        """
        return self.ends - self.starts

    def get_repeat_events(self):
        """
        Return a queryset of repeat events, not including this event.
        """
        # Fallback to `self` if `self.original` is not defined, which is the
        # case for the first event in a set.
        original = self.original or self
        # Assume that PK order will always match chronological order.
        repeat_events = type(self).objects \
            .filter(original=original, pk__gt=self.pk) \
            .order_by('pk')
        return repeat_events

    def get_rruleset(self):
        """
        Return an ``rruleset`` object for this event's repeat expression.
        """
        # TODO: Allow the selection of a repeat expression from a list of
        # presets as well.
        assert self.repeat_expression, (
            'Cannot get rruleset without a repeat expression.')
        rruleset = rrulestr(
            self.repeat_expression, dtstart=self.starts, forceset=True)
        return rruleset

    @transaction.atomic
    def save(self, propagate=False, *args, **kwargs):
        """
        When changes are detected, propagate or decouple from repeat events.
        """
        # Do not unset `original` before propagating changes. The field is
        # needed by `get_repeat_events()`.
        if not propagate and self._repeat_fields_changed():
        self.original = None
        super(AbstractEvent, self).save(*args, **kwargs)
        if propagate and self._repeat_fields_changed():
            self.propagate()
        self._store_repeat_fields()

    @transaction.atomic
    def propagate(self):
        """
        Propagate changes to existing repeat events. This will create a new set
        of repeat events with this event as the original.
        """
        # TODO: Handle `COUNT=N` rules being reset.
        self.get_repeat_events().delete()
        self.original = None
        super(AbstractEvent, self).save()  # Bypass automatic propagation.
        self.create_repeat_events()


class Event(AbstractEvent):
    pass
