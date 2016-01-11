"""
Models for ``eventkit`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.

from datetime import datetime, timedelta
from dateutil import rrule
import six

from django.core.exceptions import ValidationError
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


def default_date_starts():
    return timezone.date()


def default_date_ends():
    return default_date_starts() + appsettings.DEFAULT_DATE_ENDS_DELTA


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

    An event relies on having start information for the event. There
    are two different fields which can indicate the start date / time
    which are `starts` and `date_starts`.

    If the event is an all day event (`all_day` has been marked as
    `True`) then the `date_starts` field will be required.

    If the event is not an all day event then the `starts` field will
    be required which stores the time and date of when the event
    occurs.

    There are checks for this within the models `clean` method but this
    will not get called if the `save` method is called explicitly
    therefore care should be taken when using the `save` method to
    ensure the data meets these standards. Calling the `clean` method
    explicitly is most likely the easiest way to ensure this.
    """

    # Changes to these fields will be propagated to repeat events.
    MONITOR_FIELDS = (
        'title',
        'all_day',
        'starts',
        'ends',
        'date_starts',
        'date_ends',
        'recurrence_rule',
        'end_repeat',
        'date_end_repeat',
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
    starts = models.DateTimeField(blank=True, null=True)
    ends = models.DateTimeField(blank=True, null=True)
    date_starts = models.DateField(blank=True, null=True)
    date_ends = models.DateField(blank=True, null=True)
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
    date_end_repeat = models.DateField(
        blank=True,
        help_text=_('If empty, this event will repeat indefinitely.'),
        null=True,
    )
    is_repeat = models.BooleanField(default=False, editable=False)

    class Meta:
        abstract = True
        ordering = ('date_starts', '-all_day', 'starts')

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
        Unset ``end_repeat`` and ``date_end_repeat`` if no recurrence rule is
        set.
        """
        # TODO: Do not allow a decoupled event to have a recurrence rule that
        # is different to its parent. Recouple an event when all of its
        # monitored fields match its parent.
        if not self.recurrence_rule:
            self.end_repeat = None
            self.date_end_repeat = None

        # An event requires a start date or time. If it is an all day event it requires a start date
        # if it is not an all day event it requires a start time.
        if self.all_day:
            if not self.date_starts:
                raise ValidationError(
                    {
                        'date_starts': _(
                            'If an an event is marked as `all day` it is required to have a start '
                            'date.'
                        )
                    }
                )
        elif not self.starts:
            raise ValidationError(
                {
                    'starts': _('An event requires a start time.')
                }
            )

    @transaction.atomic
    def create_repeat_events(self, parent=None):
        """
        Create missing repeat events according to the recurrence rule, up until
        the configured limit. Return the number of repeat events created.
        """
        # TODO: Create asynchronously if celery is available?
        assert self.pk, 'Cannot create repeat events before an event is saved.'
        parent = parent or self.parent or self
        defaults = {
            field: getattr(self, field) for field in self.get_repeat_fields()
        }
        count = len(self.missing_repeat_events)
        # There is an assumption that `missing_repeat_events` will return
        # date / datetime results and never any `None` values.
        for starts in self.missing_repeat_events:
            event = type(self)(
                parent=parent,
                is_repeat=True,
                **defaults
            )
            if event.all_day:
                event.date_starts = timezone.date(starts)
                event.date_ends = timezone.date(starts) + self.duration
            else:
                event.starts = starts
                event.date_starts = timezone.date(event.starts)
                if self.duration:
                    event.ends = starts + self.duration
                    event.date_ends = timezone.date(event.ends)
            super(AbstractEvent, event).save()  # Bypass automatic propagation.
        # Refresh the MPTT fields, which are now in an inconsistent state.
        self.refresh_mptt_fields()
        return count

    @property
    def duration(self):
        """
        Return the duration between ``starts`` and ``ends`` as a timedelta.

        As a duration semantically only means something when the start and
        end times (or dates for an all day event) exist for an object if
        these criteria are not met `None` will be returned.
        """
        if self.all_day and self.date_ends and self.date_starts:
            return self.date_ends - self.date_starts
        if self.ends:
            return self.ends - self.starts
        return None

    @property
    def display_duration(self):
        """
        Return the human-readable `duration`. For all-day event, the whole
        of ``date_ends`` is accounted for in the displayed duration, so that a
        1 day all-day event will have 1 day timedelta instead of 0.

        As a duration semantically only means something when the start and
        end times (or dates for an all day event) exist for an object if
        these criteria are not met `None` will be returned.
        """
        if self.all_day and self.date_ends and self.date_starts:
            return self.date_ends + timedelta(days=1) - self.date_starts
        if self.ends:
            return self.ends - self.starts
        return None

    def get_starts(self):
        """
        Return the start date for all day events, or the start date and time
        for other events.

        If the start time / date is not set `None` will be returned as there
        is no start.
        """
        if self.all_day:
            return self.date_starts
        return self.starts
    get_starts.short_description = 'starts'

    def get_ends(self):
        """
        Return the end date for all day events, or the end date and time for
        other events.

        If the end time / date is not set `None` will be returned as there
        is no end.
        """
        if self.all_day and self.date_ends:
            return self.date_ends
        if self.ends:
            return self.ends
        return None
    get_ends.short_description = 'ends'

    def get_originating_event(self):
        """
        Return the originating event. For repeat events, this will be the
        original or variation event being repeated. For original and variation
        events, it will be ``self``.
        """
        if self.is_repeat:
            return self.parent
        return self

    def get_repeat_events(self):
        """
        Return a queryset of (future) repeat events, not including this event.
        """
        assert self.pk, 'Cannot get repeat events before an event is saved.'
        if self.is_repeat:
            # If this is a repeat event, return sibling repeat events that
            # start after it.
            events = self.get_siblings()
            if self.all_day:
                events = events.filter(date_starts__gt=self.date_starts)
            else:
                events = events.filter(starts__gt=self.starts)
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
        fields = set(self.MONITOR_FIELDS).difference([
            'starts', 'ends', 'date_starts', 'date_ends'])
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
            recurrence_rule, dtstart=self.get_starts(), forceset=True)
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

        # Get `starts` for the latest repeat event, or this event and limit
        # `end_repeat` to configured maximum.
        if self.all_day:
            starts = self.get_repeat_events() \
                .aggregate(max=models.Max('date_starts'))['max'] or \
                self.date_starts
            end_repeat = self.date_end_repeat or \
                timezone.date() + appsettings.REPEAT_LIMIT

            # `rruleset.between` for all-day requires naive datetime arguments.
            starts = datetime.combine(starts, datetime.min.time())
            end_repeat = datetime.combine(end_repeat, datetime.min.time())
        else:
            starts = self.get_repeat_events() \
                .aggregate(max=models.Max('starts'))['max'] or self.starts
            end_repeat = self.end_repeat or \
                timezone.now() + appsettings.REPEAT_LIMIT

        # `starts` and `end_repeat` are exclusive and will not be included in
        # the occurrences.
        missing = rruleset.between(starts, end_repeat)
        return missing

    @property
    def period(self):
        """
        Return "AM" or "PM", depending on when this event starts.
        """
        if self.all_day:
            return
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
        if self.all_day:
            # Remove datetime from all day events.
            self.starts = self.ends = None
        else:
            # Auto-populate date fields for regular events, so we can order by
            # date first (which all events have) and then datetime (which only
            # some events have).
            self.date_starts = timezone.date(self.starts)
            if self.ends:
                self.date_ends = timezone.date(self.ends)

        if self.all_day:
            assert self.date_starts, 'An all day event must have a start date.'
        else:
            assert self.starts, 'An event must have a start time.'
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
                        'starts',
                        'ends',
                        'date_starts',
                        'date_ends',
                        'recurrence_rule',
                    ]):
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
        if self._monitor_fields_changed([
            'starts',
            'ends',
            'date_starts',
            'date_ends',
            'recurrence_rule',
        ]):
            # When event occurrences have changed, we cannot map old events to
            # new events, so delete and recreate them.
            repeat_events.delete()
            # Update `end_repeat` field on parent and earlier repeat events to
            # avoid recreating variation events.
            if self.is_repeat:
                # Combine earlier repeat and parent events.
                siblings = type(self).objects.filter(
                    models.Q(pk=self.parent.pk) |
                    models.Q(parent__pk=self.parent_id, pk__lt=self.pk)
                ).exclude(pk=self.pk)
                # Update earlier repeat and parent events to the max `starts`
                # value found.
                starts_field = 'date_starts' if self.all_day else 'starts'
                end_repeat = siblings.aggregate(
                    max=models.Max(starts_field))['max']
                if self.all_day:
                    siblings.update(date_end_repeat=end_repeat)
                else:
                    siblings.update(
                        date_end_repeat=timezone.date(end_repeat),
                        end_repeat=end_repeat)
            # Only recreate repeat events if there is a recurrence rule.
            if self.recurrence_rule:
                # Use this variation event as the new parent for its repeat
                # events.
                self.create_repeat_events(parent=self)
        else:
            # Update. When the occurrences have not changed, we don't need to
            # delete and recreate.
            if self.all_day:
                if self.date_end_repeat and \
                        self._monitor_fields_changed('date_end_repeat'):
                    # Delete vestigial repeat events.
                    repeat_events.filter(
                        all_day=True, date_starts__gte=self.date_end_repeat
                    ).delete()
            else:
                if self.end_repeat and \
                        self._monitor_fields_changed('end_repeat'):
                    # Delete vestigial repeat events.
                    repeat_events.filter(
                        all_day=False, starts__gte=self.end_repeat
                    ).delete()
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
