"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class ImagePlugin(ContentPlugin):
    model = models.ImageItem
    category = _('Media')
    render_template = 'icekit/plugins/image/default.html'
    raw_id_fields = ['image', ]
