from fluent_pages.extensions import page_type_pool

from icekit.content_collections.page_type_plugins import ListingPagePlugin
from .models import EventListingPage


@page_type_pool.register
class EventListingPagePlugin(ListingPagePlugin):
    model = EventListingPage

    def get_context(self, request, page, **kwargs):
        context = super(EventListingPagePlugin, self).get_context(
            request, page, **kwargs)
        context['start'] = page.get_start(request)
        context['days'] = page.get_days(request)
        return context
