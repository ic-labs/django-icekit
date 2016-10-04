"""
Models for ``icekit_events`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.

from datetime import datetime, timedelta, time as datetime_time
from dateutil import rrule
import six
import pytz
from timezone import timezone

from django.core.urlresolvers import reverse
from django.conf import settings
from django.db import models, transaction
from django.db.models.query import QuerySet
from django.db.models.signals import post_save, post_delete
from django.utils import encoding
from django.utils.translation import ugettext_lazy as _
from django.utils.timezone import is_aware, is_naive, make_naive, make_aware, \
    get_current_timezone

from polymorphic.models import PolymorphicModel

from icekit.articles.abstract_models import ListingPage, SlugMixin
from icekit.fields import ICEkitURLField
from icekit.publishing.models import PublishingModel
from icekit.publishing.middleware import is_draft_request_context

from . import appsettings, validators, utils
from .utils import time as utils_time


# Constant object used as a flag for unset kwarg parameters
UNSET = object()


def zero_datetime(dt, tz=None):
    """
    Return the given datetime with hour/minutes/seconds/ms zeroed and the
    timezone coerced to the given ``tz`` (or UTC if none is given).
    """
    if dt is None:
        return None
    if tz is None:
        tz = pytz.utc
    return dt.replace(
        hour=0, minute=0, second=0, microsecond=0, tzinfo=pytz.utc)


def default_starts():
    when = utils_time.round_datetime(
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


def coerce_dt_awareness(date_or_datetime, tz=None):
    """
    Coerce the given `datetime` or `date` object into a timezone-aware or
    timezone-naive `datetime` result, depending on which is appropriate for
    the project's settings.
    """
    if tz is None:
        tz = get_current_timezone()
    if isinstance(date_or_datetime, datetime):
        dt = date_or_datetime
    else:
        dt = datetime.combine(date_or_datetime, datetime_time())
    is_project_tz_aware = settings.USE_TZ
    if is_project_tz_aware and is_naive(dt):
        return make_aware(dt, tz)
    elif not is_project_tz_aware and is_aware(dt):
        return make_naive(dt, tz)
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
class AbstractEvent(PolymorphicModel, AbstractBaseModel, PublishingModel):
    """
    An abstract polymorphic event model, with the bare minimum fields.

    An event may have associated ``Occurrence``s that determine when the event
    occurs in the calendar. An event with no occurrences does not happen at
    any particular time, and will not be shown in a calendar or time-based
    view (but may be shown in other contexts).

    An event may have zero, one, or more associated ``EventRepeatsGenerator``
    instances that define the rules for automatically generating repeating
    occurrences.
    """

    derived_from = models.ForeignKey(
        'self',
        blank=True,
        db_index=True,
        editable=False,
        null=True,
        related_name='derivitives',
    )
    title = models.CharField(max_length=255)

    show_in_calendar = models.BooleanField(
        default=True,
        help_text=_('Show this event in the public calendar'),
    )

    human_dates = models.TextField(
        blank=True,
        help_text=_('Describe event dates in humane language.'),
    )
    human_times = models.TextField(
        blank=True,
        help_text=_('Describe event times in humane language.'),
    )
    special_instructions = models.TextField(
        blank=True,
        help_text=_('Describe special instructions for attending event.'),
    )
    attendance_url = ICEkitURLField(
        blank=True,
        null=True,
        help_text=_('The URL where visitors can arrange to attend an event'
                    ' by purchasing tickets or RSVPing.')
    )

    class Meta:
        abstract = True
        ordering = ('title', 'pk')

    def __str__(self):
        return self.title

    def get_cloneable_fieldnames(self):
        return ['title']

    def add_occurrence(self, start, end=None):
        if not end:
            end = start
        return Occurrence.objects.create(
            event=self,
            start=start,
            end=end,
            generator=None,
            is_user_modified=True,
        )

    def cancel_occurrence(self, occurrence, hide_cancelled_occurrence=False,
                          reason=u'Cancelled'):
        """
        "Delete" occurrence by flagging it as deleted, and optionally setting
        it to be hidden and the reason for deletion.

        We don't really delete occurrences because doing so would just cause
        them to be re-generated the next time occurrence generation is done.
        """
        if occurrence not in self.occurrences.all():
            return  # No-op
        occurrence.is_user_modified = True
        occurrence.is_cancelled = True
        occurrence.is_hidden = hide_cancelled_occurrence
        occurrence.cancel_reason = reason
        occurrence.save()

    @transaction.atomic
    def make_variation(self, occurrence):
        """
        Make and return a variation event cloned from this event at the given
        occurrence time.
        If ``save=False`` the caller is responsible for calling ``save`` on
        both this event, and the returned variation event, to ensure they
        are saved and occurrences are refreshed.
        """
        # Clone fields from source event
        defaults = {
            field: getattr(self, field)
            for field in self.get_cloneable_fieldnames()
        }
        # Create new variation event based on source event
        variation_event = type(self)(
            derived_from=self,
            **defaults
        )
        variation_event.save()
        self.clone_relations(variation_event)

        # Adjust this event so its occurrences stop at point variation splits
        self.end_repeat = occurrence.start
        qs_overlapping_occurrences = self.occurrences \
            .filter(start__gte=occurrence.start)
        qs_overlapping_occurrences.delete()

        self.save()
        return variation_event

    def missing_occurrence_data(self, until=None):
        """
        Return a generator of (start, end, generator) tuples that are the
        datetimes and generator responsible for occurrences based on any
        ``EventRepeatsGenerator``s associated with this event.

        This method performs basic detection of existing occurrences with
        matching start/end times so it can avoid recreating those occurrences,
        which will generally be user-modified items.
        """
        existing_starts, existing_ends = get_occurrence_times_for_event(self)
        for generator in self.repeat_generators.all():
            for start, end in generator.generate(until=until):
                # Skip occurrence times when we already have an existing
                # occurrence with that start time or end time, since that is
                # probably a user-modified event
                if start in existing_starts \
                        or end in existing_ends:
                    continue
                yield(start, end, generator)

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
        count = 0
        for start_dt, end_dt, generator \
                in self.missing_occurrence_data(until=until):
            Occurrence.objects.create(
                event=self,
                generator=generator,
                start=start_dt,
                end=end_dt,
                original_start=start_dt,
                original_end=end_dt,
                is_all_day=generator.is_all_day,
            )
            count += 1
        return count

    @transaction.atomic
    def regenerate_occurrences(self, until=None):
        """
        Delete and re-create occurrences for this Event.
        """
        # Nuke any occurrences that are not user-modified
        self.occurrences.regeneratable().delete()
        # Generate occurrences for this event
        self.extend_occurrences(until=until)

    def clone_relations(self, dst_obj):
        """
        Clone related `EventRepeatsGenerator` and `Occurrence` items on publish
        """
        # Clone only the user-modified Occurrences, all others will be
        # auto-generated by the generators cloned above.
        # NOTE: Occurrences *must* be cloned first to ensure later occurrence
        # generation by cloned generators are aware of user-modifications.
        for occurrence in self.occurrences.modified_by_user():
            occurrence.pk = None
            occurrence.event = dst_obj
            occurrence.save()
        for generator in self.repeat_generators.all():
            generator.pk = None
            generator.event = dst_obj
            generator.save()

    def get_occurrences_range(self):
        """
        Return the first and last chronological `Occurrence` for this event.
        """
        first = self.occurrences.order_by('start').first()
        last = self.occurrences.order_by('-end').first()
        return (first, last)

    def describe_dates_range(self, date_format='%Y-%m-%d'):
        if self.human_dates:
            return self.human_dates
        else:
            first, last = self.get_occurrences_range()
            if not (first or last):
                return ''
            elif first and not last:
                return 'From %s' % first.start.strftime(date_format)
            elif last and not first:
                return 'To %s' % last.end.strftime(date_format)
            else:
                return ' to '.join([
                    first.start.strftime(date_format),
                    last.end.strftime(date_format)
                ])

    def describe_times_range(self, time_format='%H:%M:%S'):
        if self.human_times:
            return self.human_times
        else:
            first, last = self.get_occurrences_range()
            if not (first or last):
                return ''
            elif first and not last:
                return 'From %s' % first.start.strftime(time_format),
            elif last and not first:
                return 'To %s' % last.end.strftime(time_format)
            else:
                return ' to '.join([
                    first.start.strftime(time_format),
                    last.end.strftime(time_format)
                ])


class Event(AbstractEvent):
    """
    A concrete polymorphic event model.
    """

    class Meta:
        verbose_name = 'Event'

    def get_absolute_url(self):
        return reverse('icekit_events_event_detail', args=(self.pk,))


class EventPage(Event, SlugMixin):
    """
    A concrete polymorphic event model intended to be a URL routable page.
    """
    class Meta:
        verbose_name = 'Event Page'


class GeneratorException(Exception):
    pass


@encoding.python_2_unicode_compatible
class EventRepeatsGenerator(AbstractBaseModel):
    """
    A model storing the information and features required to generate a set
    of repeating datetimes for a given repeat rule.

    If the event is an all day event (`all_day` has been marked as
    `True`) then the `date_starts` field will be required.

    If the event is not an all day event then the `start` field will
    be required which stores the time and date of when the event
    occurs.

    There are checks for this within the models `clean` method but this
    will not get called if the `save` method is called explicitly
    therefore care should be taken when using the `save` method to
    ensure the data meets these standards. Calling the `clean` method
    explicitly is most likely the easiest way to ensure this.
    """
    event = models.ForeignKey(
        Event,
        db_index=True,
        editable=False,
        related_name='repeat_generators',
    )
    recurrence_rule = RecurrenceRuleField(
        blank=True,
        help_text=_(
            'An iCalendar (RFC2445) recurrence rule that defines when this '
            'event repeats.'),
        null=True,
    )
    start = models.DateTimeField(
        default=default_starts,
        db_index=True)
    end = models.DateTimeField(
        default=default_ends,
        db_index=True)
    is_all_day = models.BooleanField(
        default=False, db_index=True)
    repeat_end = models.DateTimeField(
        blank=True,
        help_text=_('If empty, this event will repeat indefinitely.'),
        null=True,
    )

    class Meta:
        ordering = ['pk']  # Order by PK, essentially in creation order

    def __str__(self):
        return u"EventRepeatsGenerator of '{0}'".format(self.event.title)

    def generate(self, until=None):
        """
        Return a list of datetime objects for event occurrence start and end
        times, up to the given ``until`` parameter or up to the configured
        ``REPEAT_LIMIT`` for unlimited events.
        """
        # Get starting datetime just before this event's start date or time
        # (must be just before since start & end times are *excluded* by the
        # `between` method below)
        start_dt = self.start - timedelta(seconds=1)
        # Limit `until` to provided or configured maximum, unless event has its
        # own `repeat_end` which is always respected.
        if until is None:
            if self.repeat_end:
                until = self.repeat_end
            else:
                until = timezone.now() + appsettings.REPEAT_LIMIT
        # Determine duration to add to each start time
        occurrence_duration = self.duration or timedelta(days=1)
        # `start_dt` and `until` datetimes are exclusive for our rruleset
        # lookup and will not be included
        rruleset = self.get_rruleset(until=until)
        return (
            (start, start + occurrence_duration)
            for start in rruleset.between(start_dt, until)
        )

    def get_rruleset(self, until=None):
        """
        Return an ``rruleset`` object representing the start datetimes for this
        generator, whether for one-time events or repeating ones.
        """
        # Parse complete RRULE spec into iterable rruleset
        return rrule.rrulestr(
            self._build_complete_rrule(until=until),
            forceset=True)

    def _build_complete_rrule(self, start_dt=None, until=None):
        """
        Convert recurrence rule, start datetime and (optional) end datetime
        into a full iCAL RRULE spec.
        """
        if start_dt is None:
            start_dt = self.start
        if until is None:
            until = self.repeat_end \
                or timezone.now() + appsettings.REPEAT_LIMIT
        # We assume `recurrence_rule` is always a RRULE repeat spec of the form
        # "FREQ=DAILY", "FREQ=WEEKLY", etc?
        rrule_spec = "DTSTART:%s" % format_ical_dt(start_dt)
        if not self.recurrence_rule:
            rrule_spec += "\nRDATE:%s" % format_ical_dt(start_dt)
        else:
            rrule_spec += "\nRRULE:%s" % self.recurrence_rule
            # Apply this event's end repeat
            rrule_spec += ";UNTIL=%s" % format_ical_dt(
                until - timedelta(seconds=1))
        return rrule_spec

    def save(self, *args, **kwargs):
        # End time must be equal to or after start time
        if self.end < self.start:
            raise GeneratorException(
                'End date/time must be after or equal to start date/time:'
                ' {0} < {1}'.format(self.end, self.start)
            )

        if self.repeat_end:
            # A repeat end date/time requires a recurrence rule be set
            if not self.recurrence_rule:
                raise GeneratorException(
                    'Recurrence rule must be set if a repeat end date/time is'
                    ' set: {0}'.format(self.repeat_end)
                )
            # Repeat end time must be equal to or after start time
            if self.repeat_end < self.start:
                raise GeneratorException(
                    'Repeat end date/time must be after or equal to start'
                    ' date/time: {0} < {1}'.format(self.repeat_end, self.start)
                )

        if self.is_all_day:
            # An all-day generator's start time must be at 00:00
            if self.start.hour or self.start.minute or self.start.second \
                    or self.start.microsecond:
                raise GeneratorException(
                    'Start date/time must be at 00:00:00 hours/minutes/seconds'
                    ' for all-day generators: {0}'.format(self.start)
                )

            # An all-day generator duration must be a whole multiple of days
            duration = self.duration
            if duration.seconds or duration.microseconds:
                raise GeneratorException(
                    'Duration between start and end times must be multiples of'
                    ' a day for all-day generators: {0}'.format(self.duration)
                )

        # Convert datetime field values to date-compatible versions in the
        # UTC timezone when we save an all-day occurrence
        if self.is_all_day:
            self.start = zero_datetime(self.start)
            self.end = zero_datetime(self.end)

        super(EventRepeatsGenerator, self).save(*args, **kwargs)

    @property
    def duration(self):
        """
        Return the duration between ``start`` and ``end`` as a timedelta.
        """
        return self.end - self.start

    @property
    def period(self):
        """
        Return "AM" or "PM", depending on when this event starts.
        """
        if self.is_all_day:
            return
        return 'PM' if timezone.localize(self.start).hour >= 12 else 'AM'


class OccurrenceQueryset(QuerySet):
    """ Custom queryset methods for ``Occurrence`` """

    def visible(self):
        if is_draft_request_context():
            return self.draft()
        else:
            return self.published()

    def published(self):
        return self.filter(event__publishing_is_draft=False)

    def draft(self):
        return self.filter(event__publishing_is_draft=True)

    def added_by_user(self):
        return self.filter(generator__isnull=True, is_user_modified=True)

    def modified_by_user(self):
        return self.filter(is_user_modified=True)

    def unmodified_by_user(self):
        return self.filter(is_user_modified=False)

    def generated(self):
        return self.filter(generator__isnull=False)

    def regeneratable(self):
        return self.unmodified_by_user()

    def within(self, start, end):
        """
        Return occurrences within the given start and end datetimes, inclusive.
        Special logic is applied for all-day occurrences, for which the start
        and end times are zeroed to find all occurrences that occur on a DATE
        as opposed to within DATETIMEs.
        """
        return self.filter(
                models.Q(is_all_day=False, start__gte=start) |
                models.Q(is_all_day=True,
                         start__gte=zero_datetime(start))
            ).filter(
                # Exclusive for datetime, inclusive for date.
                models.Q(is_all_day=False, start__lt=end) |
                models.Q(is_all_day=True,
                         start__lte=zero_datetime(end))
            )


OccurrenceManager = models.Manager.from_queryset(OccurrenceQueryset)
OccurrenceManager.use_for_related_fields = True


@encoding.python_2_unicode_compatible
class Occurrence(AbstractBaseModel):
    """
    A specific occurrence of an Event with start and end date times, and
    a reference back to the owner event that contains all the other data.
    """
    objects = OccurrenceManager()

    event = models.ForeignKey(
        Event,
        db_index=True,
        editable=False,
        related_name='occurrences',
    )
    generator = models.ForeignKey(
        EventRepeatsGenerator,
        blank=True, null=True)
    start = models.DateTimeField(
        db_index=True)
    end = models.DateTimeField(
        db_index=True)
    is_all_day = models.BooleanField(
        default=False, db_index=True)

    is_user_modified = models.BooleanField(
        default=False, db_index=True)

    is_cancelled = models.BooleanField(
        default=False)
    is_hidden = models.BooleanField(
        default=False)
    cancel_reason = models.CharField(
        max_length=255,
        blank=True, null=True)

    # Start/end times as originally set by a generator, before user modifiction
    original_start = models.DateTimeField(
        blank=True, null=True, editable=False)
    original_end = models.DateTimeField(
        blank=True, null=True, editable=False)

    class Meta:
        ordering = ['start', '-is_all_day', 'event', 'pk']

    def __str__(self):
        return u"""Occurrence of "{0}" {1} - {2}""".format(
            self.event.title, self.start, self.end)

    @property
    def is_generated(self):
        return self.generator is not None

    @property
    def duration(self):
        """
        Return the duration between ``start`` and ``end`` as a timedelta.
        """
        return self.end - self.start

    @transaction.atomic
    def save(self, *args, **kwargs):
        if getattr(self, '_flag_user_modification', False):
            self.is_user_modified = True
            # If and only if a Cancel reason is given, flag the Occurrence as
            # cancelled
            if self.cancel_reason:
                self.is_cancelled = True
            else:
                self.is_cancelled = False
        # Convert datetime field values to date-compatible versions in the
        # UTC timezone when we save an all-day occurrence
        if self.is_all_day:
            self.start = zero_datetime(self.start)
            self.end = zero_datetime(self.end)
        # Set original start/end times, if necessary
        if not self.original_start:
            self.original_start = self.start
        if not self.original_end:
            self.original_end = self.end
        super(Occurrence, self).save(*args, **kwargs)

    # TODO Return __str__ as title for now, improve it later
    def title(self):
        return unicode(self)

    def get_absolute_url(self):
        return reverse('icekit_events_occurrence_detail',
                       args=(self.event.pk, self.pk,))


def get_occurrence_times_for_event(event):
    """
    Return a tuple with two sets containing the (start, end) datetimes of an
    Event's Occurrences, or the original start datetime if an Occurrence's
    start was modified by a user.
    """
    occurrences_starts = set()
    occurrences_ends = set()
    for start, original_start, end, original_end in \
            event.occurrences.all().values_list('start', 'original_start',
                                                'end', 'original_end'):
        occurrences_starts.add(original_start or start)
        occurrences_ends.add(original_end or end)
    return occurrences_starts, occurrences_ends


class AbstractEventListingPage(ListingPage):

    class Meta:
        abstract = True
        verbose_name = "Event Listing"

    def get_items_to_list(self, request):
        return Occurrence.objects.published()

    def get_items_to_route(self, request):
        return Occurrence.objects.visible()


class AbstractEventListingForDatePage(ListingPage):

    class Meta:
        abstract = True
        verbose_name = "Event Listing for Date"

    def _occurrences_on_date(self, request):
        try:
            date_param = request.GET['date']
            date = datetime.strptime(date_param, '%Y-%m-%d')
        except:
            date = datetime.utcnow()
        return Occurrence.objects \
            .within(date, date + timedelta(days=1))

    def get_items_to_list(self, request):
        return self._occurrences_on_date(request).published()

    def get_items_to_route(self, request):
        return self._occurrences_on_date(request).visible()


def regenerate_event_occurrences(sender, instance, **kwargs):
    instance.event.regenerate_occurrences()
post_save.connect(regenerate_event_occurrences, sender=EventRepeatsGenerator)
post_delete.connect(regenerate_event_occurrences, sender=EventRepeatsGenerator)
