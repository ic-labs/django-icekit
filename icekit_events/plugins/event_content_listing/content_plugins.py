"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _

from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import forms, models


@plugin_pool.register
class EventContentListingPlugin(ContentPlugin):
    model = models.EventContentListingItem
    category = _('Assets')
    render_template = 'icekit_events/plugins/event_content_listing/default.html'
    form = forms.EventContentListingAdminForm
    cache_output = False
