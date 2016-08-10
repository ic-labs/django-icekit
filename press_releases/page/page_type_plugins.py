from django.conf.urls import patterns, url
from fluent_pages.extensions import page_type_pool
from icekit.plugins import ICEkitFluentContentsPagePlugin
from press_releases.models import PressRelease
from . import admin, models



# Register this plugin to the page plugin pool.
@page_type_pool.register
class PressReleaseListingPagePlugin(ICEkitFluentContentsPagePlugin):
    """
    Press Release Listing page plugin.

    Provides the listing page at the URL and forms the URL structure
    mount at the URL for individual press releases..
    """
    model = models.PressReleaseListing
    model_admin = admin.PressReleaseListingPageAdmin

    def get_context(self, request, page, **kwargs):
        c = super(PressReleaseListingPagePlugin, self).get_context(
            request, page, **kwargs)
        c.update({
            'press_releases':
                PressRelease.objects.visible().order_by("-released")
        })
        return c

    urls = patterns(
        '',
        # url('^$', 'press_releases.page.views.index',
        #     name='press-release-list'),
        url(
            '^(?P<slug>[-\w]+)/$',
            'press_releases.page.views.detail',
            name='press-release-detail'
        ),
    )
