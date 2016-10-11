from fluent_pages.extensions import page_type_pool
from icekit.content_collections.page_type_plugins import ListingPagePlugin
from .models import AuthorListing


@page_type_pool.register
class AuthorListingPlugin(ListingPagePlugin):
    model = AuthorListing
    sort_priority = 100
