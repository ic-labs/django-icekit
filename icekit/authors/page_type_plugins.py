from fluent_pages.extensions import page_type_pool
from icekit.page_types.layout_page.admin import LayoutPageAdmin

from icekit.articles.page_type_plugins import ListingPagePlugin
from .models import AuthorListing


@page_type_pool.register
class AuthorListingPlugin(ListingPagePlugin):
    model = AuthorListing
    model_admin = LayoutPageAdmin
