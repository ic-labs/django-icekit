"""
Definition of the plugin.
"""
import re

from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool
from icekit.plugins.oembed_with_caption.models import OEmbedWithCaptionItem


re_safe = re.compile(r'[^\w_-]')


@plugin_pool.register
class OEmbedWithCaptionPlugin(ContentPlugin):
    model = OEmbedWithCaptionItem
    category = _('Media')
    render_template = "icekit/plugins/oembed/default.html"

    #: Custom render template
    render_template_base = "fluent_contents/plugins/oembed/{type}.html"

    fieldsets = (
        (None, {
            'fields': (
                'embed_url',
                'caption',
            ),
        }),
    )

    class Media:
        css = {
            'screen': (
                'fluent_contents/plugins/oembed/oembed_admin.css',
            )
        }

    def get_render_template(self, request, instance, **kwargs):
        """
        Allow to style the item based on the type.
        """
        safe_filename = re_safe.sub('', instance.type or 'default')
        return [
            self.render_template_base.format(type=safe_filename),
            self.render_template
        ]
