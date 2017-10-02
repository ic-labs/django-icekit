from fluent_pages.extensions import page_type_pool

from icekit.content_collections.page_type_plugins import ListingPagePlugin
from icekit.plugins.location.models import Location

from icekit_events.models import EventType

import models


@page_type_pool.register
class AdvancedEventListingPagePlugin(ListingPagePlugin):
    model = models.AdvancedEventListingPage

    def get_context(self, request, page, **kwargs):
        context = super(AdvancedEventListingPagePlugin, self).get_context(
            request, page, **kwargs)
        # User-provided constraint data to render in page
        context['start_date'] = page.parse_start_date(request)
        context['end_date'] = page.parse_end_date(
            request, context['start_date'])
        context['days'] = (context['end_date'] - context['start_date']).days
        context['primary_types'] = page.parse_primary_types(request)
        context['secondary_types'] = page.parse_secondary_types(request)
        context['types'] = page.parse_types(request)
        context['locations'] = page.parse_locations(request)
        context['is_home_location'] = page.parse_is_home_location(request)
        # General event data to render in page
        context['visible_event_types'] = \
            EventType.objects.filter(is_public=True)
        context['visible_locations'] = Location.objects.visible()
        return context
