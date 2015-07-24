"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import forms, models


@plugin_pool.register
class TwitterEmbedPlugin(ContentPlugin):
    model = models.TwitterEmbedItem
    category = _('Media')
    render_template = 'icekit/plugins/twitter_embed/default.html'
    form = forms.TwitterEmbedAdminForm

    fieldsets = (
        (
            None, {
                'fields': ('twitter_url', )
            }
        ),
    )
