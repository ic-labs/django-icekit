"""
Fluent page plugins for the `author` app.
"""
from django.conf.urls import patterns, url
from fluent_pages.extensions import page_type_pool
from icekit.plugins import ICEkitFluentContentsPagePlugin

from ...authors.models import Author
from . import admin, models


# Register this plugin to the page plugin pool.
@page_type_pool.register
class AuthorListingPlugin(ICEkitFluentContentsPagePlugin):
    """
    Author pages page plugin.
    """
    model = models.AuthorsPage
    model_admin = admin.AuthorListingPageAdmin

    def get_context(self, request, page, **kwargs):
        c = super(AuthorListingPlugin, self).get_context(
            request, page, **kwargs)
        c.update({
            'authors':
                Author.objects.visible().order_by("family_name")
        })
        return c

    urls = patterns(
        '',
        url(
            '^(?P<slug>[-\w]+)/$',
            'icekit.authors.page.views.detail',
            name='author-detail'
        ),
    )
