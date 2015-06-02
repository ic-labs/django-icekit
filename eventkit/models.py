"""
Models for ``eventkit`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.

from dateutil import rrule
import six

from django.db import models, transaction
from django.utils import encoding
from django.utils.translation import ugettext_lazy as _
from polymorphic import PolymorphicModel
from timezone import timezone

from eventkit import appsettings, validators
from eventkit.utils import time


def default_starts():
    when = time.round_datetime(
        when=timezone.now(),
        precision=appsettings.DEFAULT_STARTS_PRECISION,
        rounding=time.ROUND_UP,
    )
    return when


def default_ends():
    return default_starts() + appsettings.DEFAULT_ENDS_DELTA


# FIELDS ######################################################################


class RecurrenceRuleField(
        six.with_metaclass(models.SubfieldBase, models.TextField)):
    """
    A ``TextField`` subclass for iCalendar (RFC2445) recurrence rules.
    """

    default_validators = [validators.recurrence_rule]
    description = _(
        'An iCalendar (RFC2445) recurrence rule that defines when an event '
        'repeats.')

    def formfield(self, **kwargs):
        from eventkit import forms  # Avoid circular import.
        defaults = {
            'form_class': forms.RecurrenceRuleField,
        }
        defaults.update(kwargs)
        return super(RecurrenceRuleField, self).formfield(**defaults)


# MODELS ######################################################################


class AbstractBaseModel(models.Model):
    """
    An abstract base model with common fields and methods for all models.

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


@encoding.python_2_unicode_compatible
class RecurrenceRule(AbstractBaseModel):
    """
    An iCalendar (RFC2445) recurrence rule. This model allows commonly needed
    or complex rules to be saved in advance, and then selected as needed when
    creating events.
    """
    description = models.TextField(
        help_text='Unique.',
        max_length=255,
        unique=True,
    )
    recurrence_rule = RecurrenceRuleField(
        help_text=_(
            'An iCalendar (RFC2445) recurrence rule that defines when an '
            'event repeats. Unique.'),
        unique=True,
    )

    def __str__(self):
        return self.description


@encoding.python_2_unicode_compatible
class AbstractEvent(PolymorphicModel, AbstractBaseModel):
    """
    An abstract polymorphic event model, with the bare minimum fields.
    """

    # Changes to these fields will be propagated to repeat events.
    MONITOR_FIELDS = (
        'title',
        'all_day',
        'starts',
        'ends',
        'recurrence_rule',
        'end_repeat',
    )

    original = models.ForeignKey('self', editable=False, null=True)
    title = models.CharField(max_length=255)
    all_day = models.BooleanField(default=False)
    starts = models.DateTimeField(default=default_starts)
    ends = models.DateTimeField(default=default_ends)
    recurrence_rule = RecurrenceRuleField(
        blank=True,
        help_text=_(
            'An iCalendar (RFC2445) recurrence rule that defines when this '
            'event repeats.'),
        null=True,
    )
    end_repeat = models.DateTimeField(
        blank=True,
        help_text=_('If empty, this event will repeat indefinitely.'),
        null=True,
    )

    class Meta:
        abstract = True
        unique_together = ('starts', 'original')

    def __init__(self, *args, **kwargs):
        """
        Store monitor field values.
        """
        super(AbstractEvent, self).__init__(*args, **kwargs)
        self._store_monitor_fields()

    def __str__(self):
        return self.title

    def _monitor_fields_changed(self, fields=None):
        """
        Return ``True`` if the given field (or any field, if None) has changed.
        """
        fields = fields or self.MONITOR_FIELDS
        if isinstance(fields, six.string_types):
            fields = [fields]
        for field in fields:
            if getattr(self, field) != self._monitor_fields[field]:
                return True
        return False

    def _store_monitor_fields(self):
        """
        Store monitor field values so we can detect and propagate changes.
        """
        self._monitor_fields = {
            k: getattr(self, k) for k in self.MONITOR_FIELDS
        }

    def clean(self):
        """
        Unset ``end_repeat`` if no recurrence rule is set.
        """
        if not self.recurrence_rule:
            self.end_repeat = None

    @transaction.atomic
    def create_repeat_events(self):
        """
        Create missing repeat events according to the recurrence rule, up until
        the configured limit.
        """
        # TODO: Create asyncronously if celery is available?
        assert self.pk, 'Cannot create repeat events before an event is saved.'
        original = self.original or self
        defaults = {
            field: getattr(self, field) for field in self.get_repeat_fields()
        }
        count = len(self.missing_repeat_events)
        for starts in self.missing_repeat_events:
            ends = starts + self.duration
            event = type(self)(
                original=original, starts=starts, ends=ends, **defaults)
            super(AbstractEvent, event).save()  # Bypass automatic propagation.
        return count

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
        assert self.pk, 'Cannot get repeat events before an event is saved.'
        # Fallback to `self` if `self.original` is not defined, which is the
        # case for the first event in a set.
        original = self.original or self
        # Assume that PK order will always match chronological order.
        repeat_events = type(self).objects \
            .filter(original=original, pk__gt=self.pk) \
            .order_by('pk')
        return repeat_events

    def get_repeat_fields(self):
        """
        Return a list of fields to be copied when creating repeat events.
        """
        fields = set(self.MONITOR_FIELDS).difference(['starts', 'ends'])
        return fields

    def get_rruleset(self):
        """
        Return an ``rruleset`` object for this event's recurrence rule.
        """
        # TODO: Allow the selection of a recurrence rule from a list of
        # presets as well.
        recurrence_rule = self.recurrence_rule
        assert recurrence_rule, (
            'Cannot get rruleset without a recurrence rule.')
        rruleset = rrule.rrulestr(
            recurrence_rule, dtstart=self.starts, forceset=True)
        return rruleset

    def is_repeat(self):
        return bool(self.original)
    is_repeat.boolean = True

    @property
    def missing_repeat_events(self):
        """
        Return a list of datetime objects for missing repeat events, up to the
        configured limit.
        """
        rruleset = self.get_rruleset()
        # Exclude existing events.
        rruleset.exdate(self.starts)
        existing = self \
            .get_repeat_events() \
            .values_list('starts', flat=True)
        for starts in existing:
            rruleset.exdate(starts)
        # Yield the `starts` datetime for each missing event.
        end_repeat = (
            self.end_repeat or timezone.now() + appsettings.REPEAT_LIMIT)
        missing = []
        # There is always at least one occurrence, even when it already exceeds
        # `end_repeat`. Don't complain about partial branch coverage.
        for starts in rruleset:  # pragma: no branch
            if starts > end_repeat:
                break
            missing.append(starts)
        return missing

    @transaction.atomic
    def save(self, propagate=False, *args, **kwargs):
        """
        When changes are detected, decouple from repeat events. If a recurrence
        rule is set or ``propagate=True``, repeat events will be updated.
        """
        recurrence_rule = self.recurrence_rule
        # Perform some gymnastics to avoid saving twice. An event needs to be
        # saved already to propagate, but we need to unset `original` after
        # propagation to decouple from repeat events.
        if self._monitor_fields_changed():
            # Propagate changes.
            if self.pk and (recurrence_rule or propagate):
                self.propagate()
            # Always decouple from repeat events when changes are detected.
            self.original = None
        already_saved = bool(self.pk)
        super(AbstractEvent, self).save(*args, **kwargs)
        # Always propagate new repeat events.
        if not already_saved and recurrence_rule:
            self.propagate()
        # Update stored fields.
        self._store_monitor_fields()

    @transaction.atomic
    def propagate(self):
        """
        Propagate changes to existing repeat events. This will create a new set
        of repeat events with this event as the original.
        """
        assert self.pk, (
            'Cannot propagate changes to repeat events before an event is '
            'saved.')
        # TODO: Handle `COUNT=N` rules being reset.
        self.get_repeat_events().delete()
        # Decouple AFTER deleting repeat events. We need the `original` field
        # to get repeat events.
        self.original = None
        # Do not try to create repeat events when no recurrence rule is set.
        if self.recurrence_rule:
            self.create_repeat_events()


class Event(AbstractEvent):
    """
    A concrete polymorphic event model.
    """
