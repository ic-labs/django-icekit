from fluent_pages.extensions import page_type_pool

from icekit.content_collections.page_type_plugins import ListingPagePlugin
from .models import ArticleCategoryPage


@page_type_pool.register
class ArticleCategoryPagePlugin(ListingPagePlugin):
    model = ArticleCategoryPage
