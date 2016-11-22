from django.conf.urls import patterns, url
from fluent_pages.extensions import page_type_pool
from fluent_pages.models import UrlNode
from haystack.views import SearchView

from icekit.plugins import ICEkitFluentContentsPagePlugin
from icekit.utils.search import ICEkitSearchForm

from . import admin, models


class FluentSearchView(SearchView):

    def __init__(self, *args, **kwargs):
        """
        This is the ludicrous way it seems you need to override the form class
        used by Haystack, to use our custom version with added field querying
        features.
        """
        super(FluentSearchView, self).__init__(*args, **kwargs)
        self.form_class = ICEkitSearchForm

    def get_context(self):
        """
        Inject 'page' into the context. Because haystack already returns a
        'page' context, rename that one to 'results_page'
        """
        context = super(FluentSearchView, self).get_context()
        context['results_page'] = context['page']
        context['page'] = UrlNode.objects.get_for_path(self.request.path)

        return context

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
            name='search'
        ),
    )
