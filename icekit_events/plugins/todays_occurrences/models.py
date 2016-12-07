from datetime import date, timedelta

from django.db import models
from django.db.models import Q
from fluent_contents.models import ContentItem
from icekit_events.models import EventType, Occurrence


class TodaysOccurrences(ContentItem):
    """
    An item that
    """
    title = models.CharField(max_length=255, blank=True, help_text="Title to show. Natural date is appended.")
    types_to_show = models.ManyToManyField(EventType, help_text="Leave empty to show all events.", blank=True, db_table="ik_todays_occurrences_types")
    include_finished = models.BooleanField(default=False, help_text="include occurrences that have already finished today")
    fall_back_to_next_day = models.BooleanField(default=True, help_text="if there are no events to show on a day, show the next day's instead.")

    class Meta:
        verbose_name = "Today's events"

    def __unicode__(self):
        return "Today's Events"

    def _calculate(self):
        today = date.today()
        self.day = today
        self.qs = Occurrence.objects.none()

        stop_days = 0 if self.fall_back_to_next_day else 365

        initial_qs = Occurrence.objects.visible().distinct()
        if self.types_to_show.count():
            types = self.types_to_show.all()
            initial_qs = initial_qs.filter(Q(event__primary_type__in=types) | Q(event__secondary_types__in=types))

        # starting from today, see if there are any occurrences.
        # Stop when we find some, or stop_days later.
        while self.day <= self.day + timedelta(days=stop_days):
            qs = initial_qs.available_on_day(self.day)
            if self.day == today and not self.include_finished:
                qs = qs.upcoming()

            if qs.count(): # found some!
                self.qs = qs
                break
            else:
                self.day += timedelta(days=1)


    def get_occurrences(self):
        if not hasattr(self, 'qs'):
            self._calculate()
        return self.qs

    def get_date(self):
        if not hasattr(self, 'day'):
            self._calculate()
        return self.day
