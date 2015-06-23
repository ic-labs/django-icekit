"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class SlideShowPlugin(ContentPlugin):
    model = models.SlideShowItem
    category = _('Image')
    render_template = 'icekit/plugins/slideshow/default.html'
    raw_id_fields = ['slide_show', ]
