"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _

from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import forms, models


@plugin_pool.register
class ContentListingPlugin(ContentPlugin):
    model = models.ContentListingItem
    category = _('Assets')
    render_template = 'icekit/plugins/content_listing/default.html'
    form = forms.ContentListingAdminForm
    cache_output = False
