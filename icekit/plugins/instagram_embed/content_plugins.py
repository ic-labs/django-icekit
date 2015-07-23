"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import forms, models


@plugin_pool.register
class InstagramEmbedPlugin(ContentPlugin):
    model = models.InstagramEmbedItem
    category = _('Media')
    render_template = 'icekit/plugins/instagram_embed/default.html'
    form = forms.InstagramEmbedAdminForm

    fieldsets = (
        (
            None, {
                'fields': ('url', )
            }
        ),
    )
