"""
Models for ``eventkit`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.

from dateutil import rrule
import six

from django.db import models, transaction
from django.utils import encoding
from django.utils.translation import ugettext_lazy as _
from model_utils import FieldTracker
from polymorphic_tree.models import \
    PolymorphicMPTTModel, PolymorphicTreeForeignKey
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
class AbstractEvent(PolymorphicMPTTModel, AbstractBaseModel):
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

    parent = PolymorphicTreeForeignKey(
        'self',
        blank=True,
        db_index=True,
        editable=False,
        null=True,
        related_name='children',
    )
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
    is_repeat = models.BooleanField(default=False, editable=False)

    class Meta:
        abstract = True

    class MPTTMeta:
        order_insertion_by = ('starts', )

    def __str__(self):
        return self.title

    def _monitor_fields_changed(self, fields=None):
        """
        Return ``True`` if the given field (or any field, if None) has changed.
        """
        fields = fields or self.MONITOR_FIELDS
        if isinstance(fields, six.string_types):
            fields = [fields]
        return bool(set(self.tracker.changed().keys()).intersection(fields))

    def clean(self):
        """
        Unset ``end_repeat`` if no recurrence rule is set.
        """
        # TODO: Do not allow a decoupled event to have a recurrence rule that
        # is different to its parent. Recouple an event when all of its
        # monitored fields match its parent.
        if not self.recurrence_rule:
            self.end_repeat = None

    @transaction.atomic
    def create_repeat_events(self, parent=None):
        """
        Create missing repeat events according to the recurrence rule, up until
        the configured limit. Return the number of repeat events created.
        """
        # TODO: Create asyncronously if celery is available?
        assert self.pk, 'Cannot create repeat events before an event is saved.'
        parent = parent or self.parent or self
        defaults = {
            field: getattr(self, field) for field in self.get_repeat_fields()
        }
        count = len(self.missing_repeat_events)
        for starts in self.missing_repeat_events:
            ends = starts + self.duration
            event = type(self)(
                parent=parent,
                starts=starts,
                ends=ends,
                is_repeat=True,
                **defaults
            )
            super(AbstractEvent, event).save()  # Bypass automatic propagation.
        # Refresh the MPTT fields, which are now in an inconsistent state.
        self.refresh_mptt_fields()
        return count

    @property
    def duration(self):
        """
        Return the duration between ``starts`` and ``ends`` as a timedelta.
        """
        return self.ends - self.starts

    def get_repeat_events(self):
        """
        Return a queryset of (future) repeat events, not including this event.
        """
        assert self.pk, 'Cannot get repeat events before an event is saved.'
        if self.is_repeat:
            # If this is a repeat event, return sibling repeat events that
            # start after it.
            events = self.get_siblings().filter(starts__gt=self.starts)
        else:
            # If this is not a repeat event, return child repeat events.
            events = self.get_children()
        # Assume that primary key order will always match chronological order,
        # because repeat events are always created in chronological order and
        # are deleted and recreated when propagating changes.
        events = events.filter(is_repeat=True).order_by('pk')
        return events

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

    def is_original(self):
        """
        Return ``True`` if this is an original (root) event.
        """
        return bool(not self.parent)
    is_original.boolean = True

    def is_variation(self):
        """
        Return ``True`` if this is a variation event.
        """
        return bool(self.parent and not self.is_repeat)
    is_variation.boolean = True

    @property
    def missing_repeat_events(self):
        """
        Return a list of datetime objects for missing repeat event occurrences,
        up to the configured limit.
        """
        rruleset = self.get_rruleset()
        # Get `starts` for the latest repeat event, or this event.
        starts = self.get_repeat_events() \
            .aggregate(max=models.Max('starts'))['max'] or self.starts
        # Limit `end_repeat` to configured maximum.
        end_repeat = (
            self.end_repeat or timezone.now() + appsettings.REPEAT_LIMIT)
        # `starts` and `end_repeat` are exclusive and will not be included in
        # the occurrences.
        missing = rruleset.between(starts, end_repeat)
        return missing

    @property
    def period(self):
        """
        Return "AM" or "PM", depending on when this event starts.
        """
        try:
            return 'PM' if timezone.localize(self.starts).hour >= 12 else 'AM'
        except AttributeError:
            pass

    @transaction.atomic
    def save(self, propagate=False, *args, **kwargs):
        """
        Unset ``is_repeat`` when monitored fields are changed, so that
        subsequent changes to earlier events will no longer affect this event.

        When ``propagate=True``, update or create repeat events.
        """
        # Is this a new event? New events cannot be propagated until saved.
        adding = self._state.adding
        # Have monitored fields have changed since the last save?
        changed = set(self.tracker.changed())
        if changed:
            # Propagate changes, before decoupling from existing repeat events.
            # Once decoupled, changes can no longer be propagated.
            if not adding:
                if propagate:
                    self.propagate(save=False)
                elif self.recurrence_rule:
                    # When occurrences have gone stale and there is still a
                    # recurrence rule set, the changes must be propagated to
                    # maintain consistency across repeat events.
                    if changed.intersection([
                            'starts', 'ends', 'recurrence_rule']):
                        raise AssertionError(
                            'Cannot update occurrences without '
                            'propagating changes to repeat events.')
                    # Unset the recurrence rule automatically when occurrences
                    # have not gone stale.
                    else:
                        self.recurrence_rule = None
                # If the only change was to remove the recurrence rule, raise
                # an exception.
                elif not changed.difference(['recurrence_rule']):
                    raise AssertionError(
                        'Cannot decouple event without any substantive '
                        'changes. Removing the recurrence rule alone is a '
                        'no-op.')
            # This is no longer a repeat event.
            self.is_repeat = False
        super(AbstractEvent, self).save(*args, **kwargs)
        # Propagate new repeat events.
        if adding and self.recurrence_rule:
            self.create_repeat_events()

    @transaction.atomic
    def propagate(self, save=True):
        """
        Propagate changes to repeat events. If the recurrence rule has not
        changed, repeat events will be updated or created. If it has changed,
        repeat events will be deleted and recreated. In both cases, this will
        become a variation event.
        """
        assert self.pk, (
            'Cannot propagate changes to repeat events before an event is '
            'saved.')
        assert self.tracker.changed(), (
            'Cannot propagate when there are no changes.')
        # TODO: Handle `COUNT=N` rules being reset.
        repeat_events = self.get_repeat_events()
        if self._monitor_fields_changed(['starts', 'ends', 'recurrence_rule']):
            # When event occurrences have changed, we cannot map old events to
            # new events, so delete and recreate them.
            repeat_events.delete()
            # Update `end_repeat` field on parent and earlier repeat events to
            # avoid recreating variation events.
            if self.is_repeat:
                # Combine earlier repeat and parent events.
                siblings = type(self).objects.filter(
                    models.Q(pk=self.parent.pk)
                    | models.Q(parent__pk=self.parent_id, pk__lt=self.pk)
                ).exclude(pk=self.pk)
                # Update earlier repeat and parent events to the max `starts`
                # value found.
                end_repeat = siblings \
                    .aggregate(max=models.Max('starts'))['max']
                siblings.update(end_repeat=end_repeat)
            # Only recreate repeat events if there is a recurrence rule.
            if self.recurrence_rule:
                # Use this variation event as the new parent for its repeat
                # events.
                self.create_repeat_events(parent=self)
        else:
            # Update. When the occurrences have not changed, we don't need to
            # delete and recreate.
            if self.end_repeat and self._monitor_fields_changed('end_repeat'):
                # Delete vestigial repeat events.
                repeat_events.filter(starts__gte=self.end_repeat).delete()
            self.update_repeat_events()
        # Decouple this variation event from earlier repeat events and save,
        # unless the caller has asked us not to save.
        self.is_repeat = False
        if save:
            self.save()

    def refresh_mptt_fields(self):
        """
        Refresh the MPTT fields on this instance from the database. Call this
        on an instance that is in an inconsistent state after rebuilding the
        MPTT tree.
        """
        event = type(self).objects.get(pk=self.pk)
        fields = (
            'left_attr',
            'right_attr',
            'tree_id_attr',
            'level_attr',
            'parent_attr',
        )
        for field in fields:
            attr = getattr(self._mptt_meta, field)
            setattr(self, attr, getattr(event, attr))

    @transaction.atomic
    def update_repeat_events(self):
        """
        Update existing repeat events.
        """
        defaults = {
            field: getattr(self, field) for field in self.get_repeat_fields()
        }
        defaults['parent'] = self
        # There is an issue with TreeManager where queries return with the meta model of the
        # first non-abstract and non-proxy model in reverse MRO order. Due to polymorphism
        # this will be Event. So any subclasses will not be able to access the fields on the
        # subclass only those of the Event model.
        # ``get_repeat_events()`` uses TreeManager queries where this occurs so we can get the list
        # of pks it would have returned and use our normal manager for the update to work around
        # this issue.
        type(self).objects.filter(pk__in=self.get_repeat_events()).update(**defaults)
        # Rebuild the MPTT tree. `update()` bypasses the `MPTTModel.save()`
        # method and leaves the tree in an inconsistent state.
        type(self)._tree_manager.partial_rebuild(self.tree_id)
        # Refresh the MPTT fields, which are now also in an inconsistent state.
        self.refresh_mptt_fields()


class Event(AbstractEvent):
    """
    A concrete polymorphic event model.
    """

    tracker = FieldTracker(AbstractEvent.MONITOR_FIELDS)
