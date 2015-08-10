"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class MapWithTextPlugin(ContentPlugin):
    model = models.MapWithTextItem
    category = _('Media')
    render_template = 'sfmoma/plugins/map_with_text/default.html'
