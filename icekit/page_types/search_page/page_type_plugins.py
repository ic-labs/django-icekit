from django.conf.urls import patterns, url
from fluent_pages.extensions import page_type_pool

from icekit.plugins import ICEkitFluentContentsPagePlugin
from icekit.utils.search import ICEkitSearchView

from . import admin, models



# Register this plugin to the page plugin pool.
@page_type_pool.register
class SearchPagePlugin(ICEkitFluentContentsPagePlugin):
    model = models.SearchPage
    model_admin = admin.SearchPageAdmin

    urls = patterns(
        '',
        url(
            r'^$',
            ICEkitSearchView.as_view(
                template_name='icekit/page_types/search_page/default.html',
            ),
            name='search'
        ),
    )
