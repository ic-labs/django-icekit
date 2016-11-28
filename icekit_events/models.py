"""
Models for ``icekit_events`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.
from collections import OrderedDict
from datetime import datetime, timedelta, time as datetime_time, time

from dateutil import rrule
import six
from django.db.models import F
from timezone import timezone as djtz  # django-timezone

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

from icekit.content_collections.abstract_models import AbstractListingPage, \
    TitleSlugMixin
from icekit.fields import ICEkitURLField
from icekit.mixins import FluentFieldsMixin
from icekit.publishing.models import PublishingModel, PublishableFluentContents
from icekit.publishing.middleware import is_draft_request_context
from django.template.defaultfilters import date as datefilter

from icekit.templatetags.icekit_tags import grammatical_join
from icekit_events.templatetags.events_tags import timesf as timesfilter
from . import appsettings, validators
from .utils import timeutils


# Constant object used as a flag for unset kwarg parameters
UNSET = object()

DATE_FORMAT = settings.DATE_FORMAT
DATETIME_FORMAT = settings.DATE_FORMAT + " " + settings.TIME_FORMAT


def zero_datetime(dt, tz=None):
    """
    Return the given datetime with hour/minutes/seconds/ms zeroed and the
    timezone coerced to the given ``tz`` (or UTC if none is given).
    """
    if tz is None:
        tz = get_current_timezone()
    return coerce_naive(dt).replace(hour=0, minute=0, second=0, microsecond=0)


def default_starts():
    when = timeutils.round_datetime(
        when=djtz.now(),
        precision=appsettings.DEFAULT_STARTS_PRECISION,
        rounding=timeutils.ROUND_UP,
    )
    return when


def default_ends():
    return default_starts() + appsettings.DEFAULT_ENDS_DELTA


def default_date_starts():
    return djtz.date()


def format_naive_ical_dt(date_or_datetime):
    """
    Return datetime formatted for use in iCal as a *naive* datetime value to
    work more like people expect, e.g. creating a series of events starting
    at 9am should not create some occurrences that start at 8am or 10am after
    a daylight savings change.
    """
    dt = coerce_dt_awareness(date_or_datetime)
    if is_naive(dt):
        return dt.strftime('%Y%m%dT%H%M%S')
    else:
        return dt.astimezone(get_current_timezone()).strftime('%Y%m%dT%H%M%S')


def coerce_dt_awareness(date_or_datetime, tz=None):
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
    if is_project_tz_aware:
        return coerce_aware(dt, tz)
    elif not is_project_tz_aware:
        return coerce_naive(dt, tz)
    # No changes necessary
    return dt


def coerce_naive(dt, tz=None):
    if is_naive(dt):
        return dt
    else:
        if tz is None:
            tz = get_current_timezone()
        return make_naive(dt, tz)


def coerce_aware(dt, tz=None):
    if is_aware(dt):
        return dt
    else:
        if tz is None:
            tz = get_current_timezone()
        return make_aware(dt, tz)

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
        default=djtz.now, db_index=True, editable=False)
    modified = models.DateTimeField(
        default=djtz.now, db_index=True, editable=False)

    class Meta:
        abstract = True
        get_latest_by = 'pk'
        ordering = ('-id', )

    def save(self, *args, **kwargs):
        """
        Update ``self.modified``.
        """
        self.modified = djtz.now()
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

class EventType(TitleSlugMixin):
    is_public = models.BooleanField(
        "Show to public?",
        default=True,
        help_text="Public types are displayed to the public, e.g. 'talk', "
                  "'workshop', etc. "
                  "Non-public types are used to indicate special behaviour, "
                  "such as education or members events."
    )

@encoding.python_2_unicode_compatible
class EventBase(PolymorphicModel, AbstractBaseModel, PublishingModel,
                TitleSlugMixin):
    """
    A polymorphic event model with all basic event features.

    An event may have associated ``Occurrence``s that determine when the event
    occurs in the calendar. An event with no occurrences does not happen at
    any particular time, and will not be shown in a calendar or time-based
    view (but may be shown in other contexts).

    An event may have zero, one, or more associated ``EventRepeatsGenerator``
    instances that define the rules for automatically generating repeating
    occurrences.
    """

    primary_type = models.ForeignKey(
        EventType, blank=True, null=True,
        help_text="The primary type of this event: Talk, workshop, etc. Only "
                  "public Event Types can be primary.",
        limit_choices_to={'is_public': True},
        related_name="events",
        on_delete=models.SET_NULL,
    )
    secondary_types = models.ManyToManyField(
        EventType, blank=True,
        help_text="Additional/internal types: Education or members events, "
                  "for example.",
        related_name="secondary_events"
    ) # use all_types to get the union of primary and secondary types

    part_of = models.ForeignKey(
        'self',
        blank=True,
        db_index=True,
        related_name="contained_events",
        null=True,
        help_text="If this event is part of another event, select it here.",
        on_delete=models.SET_NULL
    ) # access visible contained_events via get_contained_events()
    derived_from = models.ForeignKey(
        'self',
        blank=True,
        db_index=True,
        editable=False,
        null=True,
        related_name='derivitives',
        on_delete=models.SET_NULL
    )

    show_in_calendar = models.BooleanField(
        default=True,
        help_text=_('Show this event in the public calendar'),
    )

    human_dates = models.CharField(
        max_length=255,
        blank=True,
        help_text=_('Describe event dates in everyday language, e.g. "Every Sunday in March".'),
    )
    is_drop_in = models.BooleanField(
        default=False,
        help_text="Check to indicate that the event/activity can be attended at any time within the given time range."
    )
    has_tickets_available = models.BooleanField(default=False, help_text="Check to show ticketing information")
    price_line = models.CharField(
        max_length=255,
        blank=True,
        help_text='A one-line description of the price for this event, e.g. "$12 / $10 / $6"')

    special_instructions = models.TextField(
        blank=True,
        help_text=_('Describe special instructions for attending event, '
                    'e.g. "Enter via the Jones St entrance".'),
    )
    external_ref = models.CharField(
        max_length=255,
        blank=True, null=True,
        help_text="The reference identifier used by an external events/tickets management system."
    )
    cta_text = models.CharField(_("Call to action"),
        blank=True,
        max_length=255, default=_("Book now")
    )
    cta_url = ICEkitURLField(_("CTA URL"),
        blank=True,
        null=True,
        help_text=_('The URL where visitors can arrange to attend an event'
                    ' by purchasing tickets or RSVPing.')
    )

    class Meta:
        ordering = ('title', 'pk')
        verbose_name = 'Event'

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
        self.clone_event_relationships(variation_event)

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

    def publishing_clone_relations(self, src_obj):
        super(EventBase, self).publishing_clone_relations(src_obj)
        src_obj.clone_event_relationships(self)

    def clone_event_relationships(self, dst_obj):
        """
        Clone related `EventRepeatsGenerator` and `Occurrence` relationships
        from a source to destination event.
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

    def get_part_of(self):
        if self.part_of:
            return self.part_of.get_visible()

    def get_occurrences(self):
        """
        :return: My occurrences, or those of my get_part_of() event
        """
        if self.occurrences.count():
            return self.occurrences
        elif self.get_part_of():
            return self.get_part_of().get_occurrences()
        return self.occurrences # will be empty, but at least queryable

    def get_occurrences_range(self):
        """
        Return the first and last chronological `Occurrence` for this event.
        """
        first = self.get_occurrences().order_by('start').first()
        last = self.get_occurrences().order_by('-end').first()
        return (first, last)

    def get_occurrences_by_day(self):
        """
        :return: an iterable of (day, occurrences)
        """
        result = OrderedDict()

        for occ in self.get_occurrences().order_by('start'):
            result.setdefault(occ.local_start.date, []).append(occ)

        return result.items()


    def start_dates_set(self):
        """
        :return: a sorted set of all the different dates that this event
        happens on.
        """
        occurrences = self.get_occurrences().filter(
            is_cancelled=False
        )
        dates = set([o.local_start.date() for o in occurrences])
        sorted_dates = sorted(dates)
        return sorted_dates

    def start_times_set(self):
        """
        :return: a sorted set of all the different times that this event
        happens on.
        """
        occurrences = self.get_occurrences().filter(
            is_all_day=False, is_cancelled=False
        )
        times = set([o.local_start.time() for o in occurrences])
        sorted_times = sorted(times)
        return sorted_times

    def get_absolute_url(self):
        return reverse('icekit_events_eventbase_detail', args=(self.slug,))

    def get_contained_events(self):
        return EventBase.objects.filter(
            id__in=self.get_draft().contained_events.values_list('id', flat=True)
        ).visible()


    def get_cta(self):
        if self.cta_url and self.cta_text:
            return self.cta_url, self.cta_text
        return ()

    def get_all_types(self):
        return self.secondary_types.all() | EventType.objects.filter(id__in=self.primary_type_id)

    def is_educational(self):
        raise NotImplementedError

    def is_members(self):
        raise NotImplementedError


class AbstractEventWithLayouts(EventBase, FluentFieldsMixin):

    class Meta:
        abstract = True

    @property
    def template(self):
        return self.get_layout_template_name()


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
        EventBase,
        db_index=True,
        editable=False,
        related_name='repeat_generators',
        on_delete=models.CASCADE
    )
    recurrence_rule = RecurrenceRuleField(
        blank=True,
        help_text=_(
            'An iCalendar (RFC2445) recurrence rule that defines when this '
            'event repeats.'),
        null=True,
    )
    start = models.DateTimeField(
        'first start',
        default=default_starts,
        db_index=True)
    end = models.DateTimeField(
        'first end',
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
        times, up to the given ``until`` parameter, or up to the ``repeat_end``
        time, or to the configured ``REPEAT_LIMIT`` for unlimited events.
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
                until = djtz.now() + appsettings.REPEAT_LIMIT
            # For all-day occurrence generation, make the `until` constraint
            # the next date from of the repeat end date to ensure the end
            # date is included in the generated set as users expect (and
            # remembering the `between` method used below is exclusive).
            if self.is_all_day:
                until += timedelta(days=1)
        # Make datetimes naive, since RRULE spec contains naive datetimes so
        # our constraints must be the same
        start_dt = coerce_naive(start_dt)
        until = coerce_naive(until)
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
                or djtz.now() + appsettings.REPEAT_LIMIT
        # We assume `recurrence_rule` is always a RRULE repeat spec of the form
        # "FREQ=DAILY", "FREQ=WEEKLY", etc?
        rrule_spec = "DTSTART:%s" % format_naive_ical_dt(start_dt)
        if not self.recurrence_rule:
            rrule_spec += "\nRDATE:%s" % format_naive_ical_dt(start_dt)
        else:
            rrule_spec += "\nRRULE:%s" % self.recurrence_rule
            # Apply this event's end repeat date as an *exclusive* UNTIL
            # constraint. UNTIL in RRULE specs is inclusive by default, so we
            # fake exclusivity by adjusting the end time by a microsecond.
            if self.is_all_day:
                # For all-day generator, make the UNTIL constraint the last
                # microsecond of the repeat end date to ensure the end date is
                # included in the generated set as users expect.
                until += timedelta(days=1, microseconds=-1)
            else:
                until -= timedelta(microseconds=1)
            rrule_spec += ";UNTIL=%s" % format_naive_ical_dt(until)
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
            naive_start = coerce_naive(self.start)
            if naive_start.hour or naive_start.minute or naive_start.second \
                    or naive_start.microsecond:
                raise GeneratorException(
                    'Start date/time must be at 00:00:00 hours/minutes/seconds'
                    ' for all-day generators: {0}'.format(naive_start)
                )

        # Convert datetime field values to date-compatible versions in the
        # UTC timezone when we save an all-day occurrence
        if self.is_all_day:
            self.start = zero_datetime(self.start)
            self.end = zero_datetime(self.end) \
                + timedelta(days=1, microseconds=-1)

        super(EventRepeatsGenerator, self).save(*args, **kwargs)

    @property
    def duration(self):
        """
        Return the duration between ``start`` and ``end`` as a timedelta.
        """
        return self.end - self.start


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

    def overlapping(self, start, end):
        """
        :return: occurrences overlapping the given start and end datetimes,
        inclusive.
        Special logic is applied for all-day occurrences, for which the start
        and end times are zeroed to find all occurrences that occur on a DATE
        as opposed to within DATETIMEs.
        """
        return self.filter(
                models.Q(is_all_day=False, start__lt=end) |
                models.Q(is_all_day=True,
                         start__lt=zero_datetime(end))
            ).filter(
                # Exclusive for datetime, inclusive for date.
                models.Q(is_all_day=False, end__gt=start) |
                models.Q(is_all_day=True,
                         end__gte=zero_datetime(start))
            )

    def start_within(self, start, end):
        """
        :return:  occurrences that start within the given start and end
        datetimes, inclusive.
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

    def _same_day_ids(self):
        """
        :return: ids of occurrences that finish on the same day that they
        start, or midnight the next day.
        """
        # we can pre-filter to return only occurrences that are <=24h long,
        # but until at least the `__date` can be used in F() statements
        # we'll have to refine manually
        qs = self.filter(end__lte=F('start') + timedelta(days=1))

        # filter occurrences to those sharing the same end date, or
        # midnight the next day (unless it's an all-day occurrence)
        ids = [o.id for o in qs if (
            (o.local_start.date() == o.local_end.date()) or
            (
                o.local_end.time() == time(0,0) and
                o.local_end.date() == o.local_start.date() + timedelta(days=1) and
                o.is_all_day == False
            )
        )]
        return ids

    def same_day(self):
        """
        :return: occurrences that finish on the same day that they start, or
        midnight the next day.
        These types of occurrences sometimes need to be treated differently.
        """
        return self.filter(id__in=self._same_day_ids())

    def different_day(self):
        """
        :return: occurrences that finish on the a different day than they
        start, unless it's midnight the next day.
        These types of occurrences sometimes need to be treated differently.
        """
        # This is the complement of same_day above; might as well reuse the
        # logic.
        return self.exclude(id__in=self._same_day_ids())





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
        EventBase,
        db_index=True,
        editable=False,
        related_name='occurrences',
        on_delete=models.CASCADE
    )
    generator = models.ForeignKey(
        EventRepeatsGenerator,
        blank=True, null=True,
        on_delete=models.SET_NULL
    )
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

    external_ref = models.CharField(
        max_length=255,
        blank=True, null=True,
    )

    status = models.CharField(
        max_length=255,
        blank=True, null=True,
    )

    # Start/end times as originally set by a generator, before user modifiction
    original_start = models.DateTimeField(
        blank=True, null=True, editable=False)
    original_end = models.DateTimeField(
        blank=True, null=True, editable=False)

    class Meta:
        ordering = ['start', '-is_all_day', 'event', 'pk']

    def time_range_string(self):
        if self.is_all_day:
            if self.duration < timedelta(days=1):
                return u"""{0}, all day""".format(
                    datefilter(self.local_start, DATE_FORMAT))
            else:
                return u"""{0} - {1}, all day""".format(
                    datefilter(self.local_start, DATE_FORMAT),
                    datefilter(self.local_end, DATE_FORMAT))
        else:
            return u"""{0} - {1}""".format(
                datefilter(self.local_start, DATETIME_FORMAT),
                datefilter(self.local_end, DATETIME_FORMAT))

    def __str__(self):
        return u"""Occurrence of "{0}" {1}""".format(
            self.event.title,
            self.time_range_string()
        )

    @property
    def local_start(self):
        return djtz.localize(self.start)

    @property
    def local_end(self):
        return djtz.localize(self.end)

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

    def is_past(self):
        """
        :return: True if this occurrence is entirely in the past
        """
        return self.end < djtz.now()

    def get_absolute_url(self):
        return self.event.get_absolute_url()


def get_occurrence_times_for_event(event):
    """
    Return a tuple with two sets containing the (start, end) *naive* datetimes
    of an Event's Occurrences, or the original start datetime if an
    Occurrence's start was modified by a user.
    """
    occurrences_starts = set()
    occurrences_ends = set()
    for start, original_start, end, original_end in \
            event.occurrences.all().values_list('start', 'original_start',
                                                'end', 'original_end'):
        occurrences_starts.add(
            coerce_naive(original_start or start)
        )
        occurrences_ends.add(
            coerce_naive(original_end or end)
        )
    return occurrences_starts, occurrences_ends


class AbstractEventListingPage(AbstractListingPage):

    class Meta:
        abstract = True
        verbose_name = "Event Listing"

    def get_public_items(self, request):
        return Occurrence.objects.published()\
            .filter(event__show_in_calendar=True)

    def get_visible_items(self, request):
        return Occurrence.objects.visible()


class AbstractEventListingForDatePage(AbstractListingPage):

    class Meta:
        abstract = True

    def get_start(self, request):
        try:
            start = djtz.parse('%s 00:00' % request.GET.get('date'))
        except ValueError:
            start = djtz.midnight()
        return start

    def get_days(self, request):
        try:
            days = int(request.GET.get('days', appsettings.DEFAULT_DAYS_TO_SHOW))
        except ValueError:
            days = appsettings.DEFAULT_DAYS_TO_SHOW
        return days

    def _occurrences_on_date(self, request):
        days = self.get_days(request)
        start = self.get_start(request)
        end = start + timedelta(days=days)
        return Occurrence.objects.overlapping(start, end)

    def get_items_to_list(self, request):
        return self._occurrences_on_date(request).published()\
            .filter(event__show_in_calendar=True)

    def get_items_to_mount(self, request):
        return self._occurrences_on_date(request).visible()


def regenerate_event_occurrences(sender, instance, **kwargs):
    try:
        e = instance.event
    except EventBase.DoesNotExist:
        # this can happen if deleting an EventRepeatsGenerator as part of
        # deleting an event
        return
    e.regenerate_occurrences()
post_save.connect(regenerate_event_occurrences, sender=EventRepeatsGenerator)
post_delete.connect(regenerate_event_occurrences, sender=EventRepeatsGenerator)
