"""
Definition of the plugin.
"""
from django.utils.safestring import mark_safe
from fluent_contents.extensions import ContentPlugin, plugin_pool
from icekit.plugins.text.models import TextItem


@plugin_pool.register
class TextPlugin(ContentPlugin):
    model = TextItem
    admin_init_template = "icekit/plugins/text/admin/admin_init.html"  # TODO: remove the need for this.
    admin_form_template = ContentPlugin.ADMIN_TEMPLATE_WITHOUT_LABELS
    render_template = 'icekit/plugins/text/default.html'
