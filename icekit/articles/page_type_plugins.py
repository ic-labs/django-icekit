from django.conf.urls import patterns, url
from django.http import Http404
from django.template.response import TemplateResponse
from fluent_pages.extensions import page_type_pool
from icekit.page_types.layout_page.admin import LayoutPageAdmin

from icekit.plugins import ICEkitFluentContentsPagePlugin


class ListingPagePlugin(ICEkitFluentContentsPagePlugin):
    render_template = 'icekit/layouts/listing.html'
    model_admin = LayoutPageAdmin

    def get_context(self, request, page, **kwargs):
        """ Include in context items to be visible on listing page """
        context = super(ListingPagePlugin, self).get_context(
            request, page, **kwargs)
        context['items_to_list'] = page.get_items_to_list(request)
        return context

    def get_view_response(self, request, page, view_func, view_args, view_kwargs):
        """
        Render the custom view that was exposed by the extra plugin URL patterns.
        This gives the ability to add extra middleware logic.
        """
        return view_func(request, page, *view_args, **view_kwargs)

    def _detail_view(request, parent, slug):
        try:
            page = parent.get_items_to_route(request).get(slug=slug)
        except:
            raise Http404

        # If the article defines its own response, use that.
        if hasattr(page, 'get_response'):
            return page.get_response(request, parent=parent)

        raise AttributeError("Make sure to define `get_response()` in your item's model, or set `detail_view' on your Listing Page plugin.")

    detail_view = _detail_view

    urls = patterns('',
        url(
            '^(?P<slug>[-\w]+)/$',
            detail_view,
        ),
    )
