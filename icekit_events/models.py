"""
Models for ``icekit_events`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.

from datetime import datetime, timedelta, time as datetime_time
from dateutil import rrule
import six
import pytz

from django.conf import settings
from django.core.exceptions import ValidationError
from django.core.urlresolvers import reverse
from django.db import models, transaction
from django.utils import encoding
from django.utils.text import slugify
from django.utils.translation import ugettext_lazy as _
from django.utils.timezone import is_aware, is_naive, make_naive, make_aware, \
    get_current_timezone
from model_utils import FieldTracker
from polymorphic_tree.models import PolymorphicModel, PolymorphicTreeForeignKey
from timezone import timezone

from . import appsettings, validators, utils


# Constant object used as a flag for unset kwarg parameters
UNSET = object()


def default_starts():
    when = utils.time.round_datetime(
        when=timezone.now(),
        precision=appsettings.DEFAULT_STARTS_PRECISION,
        rounding=utils.time.ROUND_UP,
    )
    return when


def default_ends():
    return default_starts() + appsettings.DEFAULT_ENDS_DELTA


def default_date_starts():
    return timezone.date()


def default_date_ends():
    return default_date_starts() + appsettings.DEFAULT_DATE_ENDS_DELTA


def format_ical_dt(date_or_datetime):
    """ Return datetime formatted for use in iCal """
    dt = coerce_dt_awareness(date_or_datetime)
    if is_naive(dt):
        return dt.strftime('%Y%m%dT%H%M%S')
    else:
        return dt.astimezone(pytz.utc).strftime('%Y%m%dT%H%M%SZ')


def clone_dt_time_of_day(source_dt, target_dt):
    """
    Return `target_dt` adjusted to have the same hour/minute/second/ms time of
    day values as the `source_dt`, while keeping its own date.
    """
    # Ensure we are using the same timezone as the source to minimise
    # the chance of different date rollovers causing bugs
    if is_aware(source_dt) and is_aware(target_dt):
        target_dt = target_dt.astimezone(source_dt.tzinfo)
    # Compare hour/minute/second portions of times, ignoring date
    source_h_m_s = source_dt.utctimetuple()[3:6]
    target_h_m_s = target_dt.utctimetuple()[3:6]
    if source_h_m_s != target_h_m_s:
        # Replace target's hour/minute/second with those from source
        if is_aware(target_dt):
            target_dt = target_dt.astimezone(pytz.utc)
        return target_dt.replace(
            hour=source_h_m_s[0],
            minute=source_h_m_s[1],
            second=source_h_m_s[2],
        )
    else:
        return target_dt


def coerce_dt_awareness(date_or_datetime):
    """
    Coerce the given `datetime` or `date` object into a timezone-aware or
    timezone-naive `datetime` result, depending on which is appropriate for
    the project's settings.
    """
    if isinstance(date_or_datetime, datetime):
        dt = date_or_datetime
    else:
        dt = datetime.combine(date_or_datetime, datetime_time())
    is_project_tz_aware = settings.USE_TZ
    if is_project_tz_aware and is_naive(dt):
        return make_aware(dt, get_current_timezone())
    elif not is_project_tz_aware and is_aware(dt):
        return make_naive(dt, get_current_timezone())
    # No changes necessary
    return dt

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
        from . import forms  # Avoid circular import.
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

    # Changes to these fields will be propagated to repeat events if the
    # user has checked "propagate changes".
    # WARNING: If fields are altered in a subclass the `tracker` class
    # attribute must be redeclared in that subclass like so:
    #     tracker = FieldTracker(MONITOR_FIELDS)
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
        'show_in_calendar',
    )

    # If these fields are changed, they affect future events and so
    # will trigger a propagation, and so user must check "progagate changes"
    PROPAGATE_FIELDS = [
        'starts',
        'ends',
        'date_starts',
        'date_ends',
        'recurrence_rule',
    ]

    parent = PolymorphicTreeForeignKey(
        'self',
        blank=True,
        db_index=True,
        editable=False,
        null=True,
        related_name='children',
    )
    title = models.CharField(max_length=255)
    all_day = models.BooleanField(default=False, db_index=True)
    starts = models.DateTimeField(blank=True, null=True, db_index=True)
    ends = models.DateTimeField(blank=True, null=True)
    date_starts = models.DateField(blank=True, null=True, db_index=True)
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
    # TODO Remove field once we have a data migration tool for SFMOMA
    is_repeat = models.BooleanField(default=False, editable=False)

    show_in_calendar = models.BooleanField(
        default=True,
        help_text=_('Show this event in the public calendar'),
    )

    class Meta:
        abstract = True
        ordering = ('date_starts', '-all_day', 'starts', 'title', 'pk')

    def __init__(self, *args, **kwargs):
        """
        Sanity-check that the field tracker associated with this class tracks
        exactly the same fields as the class's ``MONITOR_FIELDS`` listing.
        This check is necessary because ``FieldTracker`` can only be declared
        on concrete classes, and must be redeclared on any subclass where the
        fields to track as defined in ``MONITOR_FIELDS`` are changed.
        """
        super(AbstractEvent, self).__init__(*args, **kwargs)
        # Confirm field tracker is defined at all
        if not hasattr(self.__class__, 'tracker'):
            raise Exception(
                "Event concrete subclass %r *must* include a field tracker"
                " attribute definition like this:\n"
                "   tracker = FieldTracker(MONITOR_FIELDS)\n"
                % type(self)
            )
        # Confirm field tracker's tracked fields == MONITOR_FIELDS
        if self.tracker.fields != set(self.MONITOR_FIELDS):
            raise Exception(
                "Fields tracked in event concrete subclass %r *must* match"
                " the fields listed in ``MONITOR_FIELDS`` but they do not."
                " Tracker fields missing: %s. Tracker extra fields: %s."
                " You probably need to redefine the field tracker attribute"
                " definition like this:\n"
                "   tracker = FieldTracker(MONITOR_FIELDS)\n"
                % (type(self),
                   set(self.MONITOR_FIELDS).difference(self.tracker.fields),
                   self.tracker.fields.difference(set(self.MONITOR_FIELDS)))
            )

    def __str__(self):
        return self.title

    def _monitor_fields_changed(self, fields=None):
        """
        Return ``True`` if the given set of fields (or ``self.MONITOR_FIELDS``
        if None) has changed.
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

        # An event requires a start date or time. If it is an all day event it
        # requires a start date if it is not an all day event it requires
        # a start time.
        if self.all_day:
            if not self.date_starts:
                raise ValidationError(
                    {
                        'date_starts': _(
                            'If an an event is marked as `all day` it is'
                            ' required to have a start date.'
                        )
                    }
                )
        elif not self.starts:
            raise ValidationError(
                {
                    'starts': _('An event requires a start time.')
                }
            )

    @property
    def duration(self):
        """
        Return the duration between ``starts`` and ``ends`` as a timedelta.

        As a duration semantically only means something when the start and
        end times (or dates for an all day event) exist for an object if
        these criteria are not met `None` will be returned.
        """
        if self.all_day and self.date_ends:
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
        if self.all_day and self.date_ends:
            return self.date_ends + timedelta(days=1) - self.date_starts
        if self.ends:
            return self.ends - self.starts
        return None

    def get_starts(self):
        """
        Return the start date for all day events, or the start date and time
        for other events.
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

    def get_future_occurrences(self):
        """
        Return a queryset of (future) occurrences, not including this event's
        original occurrence.
        """
        qs = self.occurrences
        if self.date_starts:
            qs = self.occurrences.filter(
                starts__gte=coerce_dt_awareness(self.date_starts))
        else:
            qs = self.occurrences.filter(starts__gt=self.starts)
        return qs.order_by('starts')  # Ensure chronological ordering

    def get_variation_fields(self):
        """
        Return a list of fields to be copied when creating repeat events.
        """
        fields = set(self.MONITOR_FIELDS).difference([
            'starts', 'ends', 'date_starts', 'date_ends'])
        return fields

    def get_rruleset(self):
        """
        Return an ``rruleset`` object representing ALL the occurrence times for
        this event, whether for one-time events or repeating ones.
        """
        # Parse complete RRULE spec into iterable rruleset
        return rrule.rrulestr(self._build_complete_rrule(), forceset=True)

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

    def add_occurrence(self, starts, ends=None):
        if not ends:
            ends = starts + self.duration
        return Occurrence.objects.create(
            event=self,
            starts=starts,
            ends=ends,
            is_generated=False,
            is_user_modified=True,
        )

    def delete_occurrence(self, occurrence, hide_deleted_occurrence=False,
                          reason=u'Cancelled'):
        """
        "Delete" occurrence by flagging it as deleted, and optionally setting
        it to be hidden and the reason for deletion.

        We don't really delete occurrences because doing so would just cause
        them to be re-generated the next time occurrence generation is done.
        """
        if occurrence not in self.occurrences.all():
            # TODO Should we raise an error here?
            return
        occurrence.is_user_modified = True
        occurrence.is_deleted = True
        occurrence.is_hidden = hide_deleted_occurrence
        occurrence.deleted_reason = reason
        occurrence.save()

    # TODO Do we need `undelete_occurrence`?

    def missing_occurrence_datetimes(self, until=None):
        """
        Return a list of datetime objects for missing event occurrences, up to
        the event's ``end_repeat`` if set, or the time given by the ``until``
        parameter or the configured ``REPEAT_LIMIT`` for unlimited events.
        """
        # Get starting datetime just before this event's start date or time
        # (must be just before since start & end times are *excluded* by the
        # `between` method below)
        if self.date_starts:
            starts = coerce_dt_awareness(self.date_starts)
        else:
            starts = self.starts
        starts -= timedelta(seconds=1)
        # Limit `until` to provided or configured maximum, unless event has its
        # own `end_repeat` which is always respected.
        if self.end_repeat:
            until = self.end_repeat
        elif until is None:
            until = timezone.now() + appsettings.REPEAT_LIMIT
        rruleset = self.get_rruleset()
        # `starts` and `until` datetimes are exclusive for our rruleset lookup
        # and will not be included
        return [
            dt for dt in rruleset.between(starts, until)
            # Exclude any datetimes for which we already have occurrences
            if dt not in get_occurrences_start_datetimes_for_event(self)
        ]

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
    def make_variation(self, occurrence,
                       recurrence_rule=UNSET, end_repeat=UNSET,
                       save=True):
        """
        Make and return a variation event cloned from this event at the given
        occurrence time.
        If ``save=False`` the caller is responsible for calling ``save`` on
        both this event, and the returned variation event, to ensure they
        are saved and occurrences are refreshed.
        """
        # Clone fields from parent
        # TODO Add special handling to clone extra data from original event?
        defaults = {
            field: getattr(self, field)
            for field in self.get_variation_fields()
        }
        # Apply overrides for fields, if provided
        if recurrence_rule is not UNSET:
            defaults['recurrence_rule'] = recurrence_rule
        if end_repeat is not UNSET:
            defaults['end_repeat'] = end_repeat
        # Create new variation event based on parent
        variation = type(self)(
            parent=self,
            starts=occurrence.starts,
            ends=occurrence.ends,
            **defaults
        )
        # Adjust this event so its occurrences stop at point variation splits
        # TODO Is this really what we want at all?
        self.end_repeat = occurrence.starts
        qs_overlapping_occurrences = self.occurrences \
            .filter(starts__gte=occurrence.starts)
        if end_repeat is not UNSET:
            qs_overlapping_occurrences = qs_overlapping_occurrences \
                .filter(starts__lt=end_repeat)
        qs_overlapping_occurrences.delete()

        if save:
            variation.save()
            self.save()
        return variation

    def _build_complete_rrule(self, starts=None, end_repeat=None):
        """
        Convert recurrence rule, starts date and (optional) end date to a full
        iCAL RRULE spect.
        """
        if starts is None:
            starts = self.date_starts or self.starts
        if end_repeat is None:
            end_repeat = self.end_repeat
        # TODO Safe to assume `recurrence_rule` is always a RRULE repeat spec
        # of the form "FREQ=DAILY", "FREQ=WEEKLY", etc?
        rrule_spec = "DTSTART:%s" % format_ical_dt(starts)
        if not self.recurrence_rule:
            rrule_spec += "\nRDATE:%s" % format_ical_dt(starts)
        else:
            rrule_spec += "\nRRULE:%s" % self.recurrence_rule
            # Apply this event's end repeat, if available...
            if end_repeat:
                rrule_spec += ";UNTIL=%s" % format_ical_dt(
                    end_repeat - timedelta(seconds=1))
            # ...otherwise, for efficiency, use the earliest start date of any
            # repeating and unlimited child variation as this event's end. The
            # rrule library doesn't cope well with nested unlimited repeats.
            else:
                candidate_starts = []
                for variation in self.children.all():
                    if variation.recurrence_rule and not variation.end_repeat:
                        candidate_starts.append(variation.starts)
                if candidate_starts:
                    rrule_spec += ";UNTIL=%s" % format_ical_dt(
                        min(candidate_starts) - timedelta(seconds=1))
        return rrule_spec

    @transaction.atomic
    def save(self, regenerate_occurrences=True, *args, **kwargs):
        """
        When ``regenerate_occurrences=True``, refresh occurrences.
        """
        # Is this a new event?
        adding = self._state.adding
        # Have monitored fields have changed since the last save?
        changed = set(self.tracker.changed())
        super(AbstractEvent, self).save(*args, **kwargs)
        if changed and changed.intersection([
                'starts', 'ends', 'recurrence_rule', 'end_repeat']):
            if regenerate_occurrences:
                self.regenerate_occurrences()
            else:
                assert adding, (
                    'Cannot save changes to event occurrence fields on an'
                    ' existing event without regenerating occurrences')

    @transaction.atomic
    def extend_occurrences(self, until=None):
        """
        Create missing occurrences for this Event, assuming that existing
        occurrences are all correct (or have been pre-deleted).
        This is mostly useful for adding not-yet-created future occurrences
        with a scheduled job, e.g. via the `create_event_occurrences` command.
        Occurrences are extended up to the event's ``end_repeat`` if set, or
        the time given by the ``until`` parameter or the configured
        ``REPEAT_LIMIT`` for unlimited events.
        """
        # Create occurrences for this event
        missing_datetimes = self.missing_occurrence_datetimes(until)
        for starts in missing_datetimes:
            if self.duration:
                ends = starts + self.duration
            else:
                ends = starts
            Occurrence.objects.create(
                event=self,
                starts=starts,
                ends=ends,
            )
        return len(missing_datetimes)

    @transaction.atomic
    def regenerate_occurrences(self, until=None, with_parent=True):
        """
        Delete and re-create occurrences for this Event, and its parent if this
        is a variation event.
        Occurrences are extended up to the event's ``end_repeat`` if set, or
        the time given by the ``until`` parameter or the configured
        ``REPEAT_LIMIT`` for unlimited events.
        """
        # Nuke existing occurrences
        self.occurrences.all().delete()
        # Create occurrences for this event
        self.extend_occurrences(until)
        # Regenerate parent's events, which might be affected by changes in
        # this variation.
        if self.parent and with_parent:
            self.parent.regenerate_occurrences()

    def calendar_classes(self):
        """
        Return css classes to be used in admin calendar JSON
        """
        classes = [slugify(self.polymorphic_ctype.name)]

        # quick-and-dirty way to get a color for the type.
        # There are 12 colors defined in the css file
        classes.append("color-%s" % (self.polymorphic_ctype_id % 12))

        # Add a class name for the type of event.
        if self.is_repeat:
            classes.append('is-repeat')
        elif not self.parent:
            classes.append('is-original')
        else:
            classes.append('is-variation')

        # if an event isn't published or does not have show_in_calendar ticked,
        # indicate that it is hidden
        if not self.show_in_calendar:
            classes.append('do-not-show-in-calendar')

        # Prefix class names with "fcc-" (full calendar class).
        classes = ['fcc-%s' % class_ for class_ in classes]

        return classes

    def calendar_json(self):
        """
        Return JSON for a single event
        """
        # Slugify the plugin's verbose name for use as a class name.
        if self.all_day:
            start = self.date_starts
            # `end` is exclusive according to the doc in
            # http://fullcalendar.io/docs/event_data/Event_Object/, so
            # we need to add 1 day to ``date_ends`` to have the end date
            # included in the calendar.
            end = (self.date_ends or self.date_starts) + timedelta(days=1)
        else:
            start = timezone.localize(self.starts)
            end = timezone.localize(self.ends)
        return {
            'title': self.title,
            'allDay': self.all_day,
            'start': start,
            'end': end,
            'url': reverse(
                'admin:icekit_events_event_change', args=[self.pk]),
            'className': self.calendar_classes(),
        }


class Event(AbstractEvent):
    """
    A concrete polymorphic event model.
    """
    tracker = FieldTracker(AbstractEvent.MONITOR_FIELDS)


# TODO Custom Occurrence manager to show useful collections of occurrences,
# such as those that are not user-modified, not deleted, not hidden,
# within time bounds etc.


@encoding.python_2_unicode_compatible
class Occurrence(AbstractBaseModel):
    """
    A specific occurrence of an Event with start and end date times, and
    a reference back to the owner event that contains all the other data.
    """
    event = PolymorphicTreeForeignKey(
        Event,
        db_index=True,
        editable=False,
        related_name='occurrences',
    )
    starts = models.DateTimeField(
        default=default_starts,
        db_index=True)
    ends = models.DateTimeField(
        default=default_ends)

    is_generated = models.BooleanField(
        default=False, db_index=True)
    is_user_modified = models.BooleanField(
        default=False, db_index=True)

    is_deleted = models.BooleanField(
        default=False)
    is_hidden = models.BooleanField(
        default=False)
    deleted_reason = models.CharField(
        max_length=255)

    # TODO `original_starts` and `original_ends` fields

    class Meta:
        ordering = ['starts']

    def __str__(self):
        return """Occurrence of "{0}" {1} - {2}""".format(
            self.event.title, self.starts, self.ends)

    @property
    def duration(self):
        """
        Return the duration between ``starts`` and ``ends`` as a timedelta.

        As a duration semantically only means something when the start and
        end times (or dates for an all day event) exist for an object if
        these criteria are not met `None` will be returned.
        """
        if self.ends:
            return self.ends - self.starts
        return None


def get_occurrences_start_datetimes_for_event(event):
    """ Return a set of `starts` field values for an Event's Occurrences """
    # TODO Account for `original_starts` field once we have one
    return set(event.occurrences.all().values_list('starts', flat=True))
