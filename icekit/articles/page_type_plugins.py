from django.conf.urls import patterns, url
from django.http import Http404
from django.template.response import TemplateResponse
from fluent_pages.extensions import page_type_pool
from icekit.page_types.layout_page.admin import LayoutPageAdmin

from icekit.plugins import ICEkitFluentContentsPagePlugin


class ListingPagePlugin(ICEkitFluentContentsPagePlugin):
    render_template = 'icekit/layouts/listing.html'
    model_admin = LayoutPageAdmin

    # TODO Awful hack to make request available to listing page class as
    # `_request` class attribute. There must be a better way...
    def get_response(self, request, page, **kwargs):
        page._plugin_request = request
        return super(ListingPagePlugin, self).get_response(
            request, page, **kwargs)

    def get_view_response(self, request, page, view_func, view_args, view_kwargs):
        """
        Render the custom view that was exposed by the extra plugin URL patterns.
        This gives the ability to add extra middleware logic.
        """
        return view_func(request, page, *view_args, **view_kwargs)


    def _detail_view(request, parent, slug):
        try:
            page = parent.get_visible_items().get(slug=slug)
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
