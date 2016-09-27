from fluent_pages.extensions import page_type_pool
from icekit.page_types.layout_page.admin import LayoutPageAdmin
from icekit.articles.page_type_plugins import ListingPagePlugin
from .models import ArticleCategoryPage


@page_type_pool.register
class ArticleCategoryPagePlugin(ListingPagePlugin):
    model = ArticleCategoryPage
    model_admin = LayoutPageAdmin
