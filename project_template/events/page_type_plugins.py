from fluent_pages.extensions import page_type_pool

from icekit.articles.page_type_plugins import ListingPagePlugin

from .models import EventListingPage


@page_type_pool.register
class EventListingPagePlugin(ListingPagePlugin):
    model = EventListingPage
