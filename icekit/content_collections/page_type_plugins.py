from django.conf.urls import patterns, url
from django.core.exceptions import ObjectDoesNotExist
from django.http import Http404
from icekit.page_types.layout_page.admin import LayoutPageAdmin

from icekit.plugins import ICEkitFluentContentsPagePlugin


class ListingPagePlugin(ICEkitFluentContentsPagePlugin):
    # render_template = 'icekit_content_collections/layouts/collection.html'
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

    def collected_content_view(request, parent, slug):
        try:
            # using .visible() here to acknowledge IS_DRAFT context.
            page = parent.get_items_to_mount(request).get(slug=slug)
        except ObjectDoesNotExist:
            raise Http404

        # If the item defines its own response, use that.
        if hasattr(page, 'get_response'):
            return page.get_response(request, parent=parent)
        else:
            raise AttributeError("You need to define `%s.get_response(request, parent)`, or override `collected_content_view` in your `ListingPagePlugin` class" % (type(page).__name__))

    urls = patterns('',
        url(
            '^(?P<slug>[-\w]+)/$',
            collected_content_view,
        ),
    )
