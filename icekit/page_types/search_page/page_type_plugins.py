from django.conf.urls import patterns, url
from fluent_pages.extensions import page_type_pool
from fluent_pages.models import UrlNode
from haystack.views import SearchView

from . import admin, models
from icekit.plugins import ICEkitFluentContentsPagePlugin


class FluentSearchView(SearchView):
    def extra_context(self):
        return {
            'instance': UrlNode.objects.get_for_path(self.request.path)
        }


# Register this plugin to the page plugin pool.
@page_type_pool.register
class SearchPagePlugin(ICEkitFluentContentsPagePlugin):
    model = models.SearchPage
    model_admin = admin.SearchPageAdmin

    urls = patterns(
        '',
        url(
            r'^$',
            FluentSearchView(
                template='icekit/page_types/search_page/default.html',
            ),
            name='haystack_search'
        ),
    )
