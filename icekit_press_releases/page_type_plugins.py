from fluent_pages.extensions import page_type_pool

from icekit.content_collections.page_type_plugins import ListingPagePlugin
from icekit.page_types.layout_page.admin import LayoutPageAdmin
from .models import PressReleaseListing


@page_type_pool.register
class PressReleaseListingPlugin(ListingPagePlugin):
    model = PressReleaseListing
    sort_priority = 100
