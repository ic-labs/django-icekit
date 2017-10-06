from datetime import timedelta
from timezone import timezone as djtz  # django-timezone

from django.db import models

from icekit.content_collections.abstract_models import AbstractListingPage

from icekit_events.models import Occurrence, EventType
from icekit_events import appsettings
from icekit.plugins.location.models import Location


class AbstractAdvancedEventListingPage(AbstractListingPage):

    limit_to_primary_types = models.ManyToManyField(
        EventType,
        help_text="Leave empty to show all events.",
        blank=True,
        # Explicit `db_table` required to avoid errors creating FK constraints
        db_table="advanced_event_listing_page_primary_types",
        related_name="+",
    )
    limit_to_secondary_types = models.ManyToManyField(
        EventType,
        help_text="Leave empty to show all events.",
        blank=True,
        # Explicit `db_table` required to avoid errors creating FK constraints
        db_table="advanced_event_listing_page_secondary_types",
        related_name="+",
    )
    limit_to_locations = models.ManyToManyField(
        'icekit_plugins_location.Location',
        limit_choices_to={'publishing_is_draft': True},
        help_text="Leave empty to show all events.",
        blank=True,
        # Explicit `db_table` required to avoid errors creating FK constraints
        db_table="advanced_event_listing_page_locations",
    )
    limit_to_home_locations = models.BooleanField(
        default=False,
    )
    default_start_date = models.DateField(
        blank=True, null=True,
        help_text=(
            "Default start date for event occurrences when the user has not"
            " selected a value. Leave empty to use today's date"
        )
    )
    default_days_to_show = models.IntegerField(
        blank=True, null=True,
        help_text=(
            "Default period in days after the start date to show event"
            " occurrences when the user has not selected a value. Leave empty"
            " to use the value from Events setting "
            " `appsettings.DEFAULT_DAYS_TO_SHOW`"
        )
    )

    class Meta:
        abstract = True

    def parse_start_date(self, request):
        """
        Return start date for event occurrences, which is one of the following
        in order of priority:
         - `start_date` GET parameter value, if given and valid
         - page's `default_start_date` if set
         - today's date
        """
        if request.GET.get('start_date'):
            try:
                return djtz.parse('%s 00:00' % request.GET.get('start_date'))
            except ValueError:
                pass
        return self.default_start_date or djtz.midnight()

    def parse_end_date(self, request, start_date):
        """
        Return period in days after the start date to show event occurrences,
        which is one of the following in order of priority:
         - `end_date` GET parameter value, if given and valid. The filtering
           will be *inclusive* of the end date: until end-of-day of this date
         - `days_to_show` GET parameter value, if given and valid
         - page's `default_days_to_show` if set
         - the value of the app setting `DEFAULT_DAYS_TO_SHOW`
        """
        if request.GET.get('end_date'):
            try:
                return djtz.parse('%s 00:00' % request.GET.get('end_date'))
            except ValueError:
                pass
        days_to_show = self.default_days_to_show or \
            appsettings.DEFAULT_DAYS_TO_SHOW
        if 'days_to_show' in request.GET:
            try:
                days_to_show = int(request.GET.get('days_to_show'))
            except ValueError:
                pass
        return start_date + timedelta(days=days_to_show)

    def parse_primary_types(self, request):
        """
        Return primary event types that occurrences must belong to, or `None`
        if there is no constraint on primary type.
        """
        if request.GET.getlist('primary_types'):
            return EventType.objects.get(
                slug__in=request.GET.getlist('primary_types'))
        return None

    def parse_secondary_types(self, request):
        """
        Return secondary event types that occurrences must belong to, or `None`
        if there is no constraint on secondary type.
        """
        if request.GET.getlist('secondary_types'):
            return EventType.objects.filter(
                slug__in=request.GET.getlist('secondary_types'))
        return None

    def parse_types(self, request):
        """
        Return  event types that occurrences must belong to as *either* a
        primary or secondary type, or `None` if there is no constraint on type.
        """
        if request.GET.getlist('types'):
            return EventType.objects.filter(
                slug__in=request.GET.getlist('types'))
        return None

    def parse_locations(self, request):
        if request.GET.getlist('locations'):
            return Location.objects.filter(
                slug__in=request.GET.getlist('locations'))
        return None

    def parse_is_home_location(self, request):
        if 'is-home-location' in request.GET:
            try:
                return bool(request.GET['is-home-location'])
            except ValueError:
                pass
        return None

    def parse_is_nearby(self, request):
        if request.GET.get('is-nearby'):
            try:
                splits = request.GET.get('is-nearby').split(',')
                lat, lng, distance = map(float, splits)
                return lat, lng, distance
            except ValueError:
                pass
        return None

    def _apply_constraints(self, request):
        start_date = self.parse_start_date(request)
        end_date = self.parse_end_date(request, start_date)

        # Find occurrences between start and end dates
        qs = Occurrence.objects.overlapping(
            start_date,
            end_date + timedelta(days=1)  # End date is inclusive
        )

        # Filter occurrences to match any constraints defined in page FKs
        if self.limit_to_primary_types.count():
            primary_types = self.limit_to_primary_types.all()
            qs = qs.filter(
                event__primary_type__in=primary_types)
        if self.limit_to_secondary_types.count():
            secondary_types = self.limit_to_secondary_types.all()
            qs = qs.filter(
                event__secondary_types__in=secondary_types)
        if self.limit_to_locations.count():
            locations = self.limit_to_locations.all()
            qs = qs.filter(
                event__location__in=locations)
        if self.limit_to_home_locations:
            qs = qs.filter(
                event__location__is_home_location=True)

        # Further filter occcurrences to match any constraints applied through
        # request parameters
        primary_types = self.parse_primary_types(request)
        if primary_types:
            qs = qs.filter(event__primary_type__in=primary_types)
        secondary_types = self.parse_secondary_types(request)
        if secondary_types is not None:
            qs = qs.filter(event__secondary_types__in=secondary_types)
        types = self.parse_types(request)
        if types is not None:
            qs = qs.filter(
                models.Q(event__secondary_types__in=types) |
                models.Q(event__primary_type__in=types)
            )
        locations = self.parse_locations(request)
        if locations is not None:
            qs = qs.filter(event__location__in=locations)
        nearby_locations_constraint = self.parse_is_nearby(request)
        if nearby_locations_constraint:
            lat, lng, distance = nearby_locations_constraint
            self.nearby_locations = Location.objects \
                .nearby(lat, lng, distance) \
                .visible()
            qs = qs.filter(event__location__in=self.nearby_locations)
        is_home_location = self.parse_is_home_location(request)
        if is_home_location is not None:
            qs = qs.filter(event__location__is_home_location=is_home_location)

        return qs

    def get_items_to_mount(self, request):
        """ Return items that can be mounted, i.e. viewed as child pages """
        return self._apply_constraints(request).visible()

    def get_items_to_list(self, request):
        """
        Return items that can be seen on the listing page by current user
        """
        return self._apply_constraints(request).visible()


class AdvancedEventListingPage(AbstractAdvancedEventListingPage):

    class Meta:
        verbose_name = "Advanced Event listing"
