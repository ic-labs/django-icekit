"""
Models for ``icekit_events`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.
from collections import OrderedDict
from datetime import datetime, timedelta, time

from django.db.models import F
from django.utils.timezone import make_aware
from icekit.publishing.managers import PublishingPolymorphicManager, \
    PublishingPolymorphicQuerySet

from django.db import models
from django.db.models.query import QuerySet, Prefetch
from django.db.models import Q
from icekit.publishing.middleware import is_draft_request_context
from timezone.timezone import now, localize

from icekit_events.utils.timeutils import zero_datetime, coerce_dt_awareness
from timezone import timezone as djtz  # django-timezone


class EventQueryset(PublishingPolymorphicQuerySet):

    def with_upcoming_occurrences(self):
        """
        :return: events having upcoming occurrences, and all their children
        """
        return self.filter(
            Q(is_drop_in=False, occurrences__start__gte=datetime.now) |
            Q(Q(is_drop_in=True) | Q(occurrences__is_all_day=True), occurrences__end__gt=datetime.now)
        )

    def with_no_occurrences(self):
        return self.filter(occurrences=None)

    def with_upcoming_or_no_occurrences(self):
        """
        :return:
        """
        ids = set(self.with_upcoming_occurrences().values_list('id', flat=True)) | set(self.with_no_occurrences().values_list('id', flat=True))
        return self.model.objects.filter(id__in=ids)

    def with_occurrence_qs(self, occ_qs):
        return self.filter(occurrences__in=occ_qs)

    def overlapping(self, start, end):
        from icekit_events.models import Occurrence
        return self.with_occurrence_qs(Occurrence.objects.overlapping(start, end))

    def starts_within(self, start, end):
        from icekit_events.models import Occurrence
        return self.with_occurrence_qs(Occurrence.objects.starts_within(start, end))

    def available_within(self, start, end):
        from icekit_events.models import Occurrence
        return self.with_occurrence_qs(Occurrence.objects.available_within(start, end))

    def upcoming(self):
        from icekit_events.models import Occurrence
        return self.with_occurrence_qs(Occurrence.objects.upcoming()).distinct()

    def order_by_first_occurrence(self):
        """
        :return: The event in order of minimum occurrence. 
        """
        def _key(e):
            try:
                return e.occurrence_list[0].start
            except IndexError: # no occurrences; put last
                return localize(datetime.max - timedelta(days=365))

        return sorted(list(self), key=_key)

    def order_by_next_occurrence(self):
        """
        
        :return: A list of events in order of minimum occurrence greater than 
        now (or overlapping now in the case of drop-in events). 
        
        This is an expensive operation - use with as small a source 
        queryset as possible.
        
        Events with no upcoming occurrence appear last (in order of their first 
        occurrence). Events with no occurrences at all appear right at the end 
        (in no order). To remove these, use "with_upcoming_occurrences" or 
        "with_upcoming_or_no_occurrences".
        """

        qs = self.prefetch_related('occurrences')
        def _sort(x):
            try:
                # If there's an upcoming occurrence, use it.
                return x.get_next_occurrence().start
            except AttributeError:
                try:
                    # If there's any occurrence, use the first one, plus 1000 years.
                    return x.get_first_occurrence().start + timedelta(days=1000*365)
                except AttributeError:
                    # If no occurence, use a localised datetime.max (minus a
                    # few days to avoid overflow)
                    return make_aware(datetime.max-timedelta(2))

        sorted_qs = sorted(qs, key=_sort)

        return sorted_qs


EventManager = PublishingPolymorphicManager.from_queryset(EventQueryset)
EventManager.use_for_related_fields = True



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
        return self.filter(generator__isnull=True, is_protected_from_regeneration=True)

    def protected_from_regeneration(self):
        return self.filter(is_protected_from_regeneration=True)

    def unprotected_from_regeneration(self):
        return self.filter(is_protected_from_regeneration=False)

    def generated(self):
        return self.filter(generator__isnull=False)

    def regeneratable(self):
        return self.unprotected_from_regeneration()

    def overlapping(self, start=None, end=None):
        """
        :return: occurrences overlapping the given start and end datetimes,
        inclusive.
        Special logic is applied for all-day occurrences, for which the start
        and end times are zeroed to find all occurrences that occur on a DATE
        as opposed to within DATETIMEs.
        """
        qs = self

        if start:
            dt_start=coerce_dt_awareness(start)
            qs = qs.filter(
                # Exclusive for datetime, inclusive for date.
                Q(is_all_day=False, end__gt=dt_start) |
                Q(is_all_day=True, end__gte=zero_datetime(dt_start))
            )
        if end:
            dt_end=coerce_dt_awareness(end, t=time.max)
            qs = qs.filter(
                Q(is_all_day=False, start__lt=dt_end) |
                Q(is_all_day=True, start__lt=zero_datetime(dt_end))
            )

        return qs


    def starts_within(self, start=None, end=None):
        """
        :return:  normal occurrences that start within the given start and end
        datetimes, inclusive, and drop-in occurrences that 
        """

        qs = self

        if start:
            dt_start=coerce_dt_awareness(start)
            qs = qs.filter(
                Q(is_all_day=False, start__gte=dt_start) |
                Q(is_all_day=True, start__gte=zero_datetime(dt_start))
            )
        if end:
            dt_end=coerce_dt_awareness(end, t=time.max)
            qs = qs.filter(
                # Exclusive for datetime, inclusive for date.
                Q(is_all_day=False, start__lt=dt_end) |
                Q(is_all_day=True, start__lte=zero_datetime(dt_end))
            )

        return qs

    def available_within(self, start=None, end=None):
        """
        :return: Normal events that start within the range, and
         drop-in events that overlap the range.
        """
        return self.filter(event__is_drop_in=False).starts_within(start, end) | \
               self.filter(event__is_drop_in=True).overlapping(start, end)

    def available_on_day(self, day):
        """
        Return events that are available on a given day.
        """
        if isinstance(day, datetime):
            d = day.date()
        else:
            d = day
        return self.starts_within(d, d)

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

    def upcoming(self):
        """
        :return: If the event is drop-in, return occurrences that overlap now
        until any time in the future. If the event is not drop-in, return
        occurrences that start in the future.
        
        Occurrences are ordered by their `start` by default.
        """
        return self.available_within(start=djtz.now(), end=None)

    def next_occurrence(self):
        """
        :return: The next occurrence of the event, or current occurrence if
        the event is a drop-in.
        """
        try:
            return self.upcoming()[0]
        except IndexError:
            return None

OccurrenceManager = models.Manager.from_queryset(OccurrenceQueryset)
OccurrenceManager.use_for_related_fields = True
# monkeypatch in a default queryset
def _get_queryset(self):
    return super(OccurrenceManager, self).get_queryset().select_related('event')
OccurrenceManager.get_queryset = _get_queryset
