"""
Definition of the plugin.
"""
import warnings
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class QuotePlugin(ContentPlugin):
    model = models.QuoteItem
    category = _('Text')
    render_template = 'icekit/plugins/quote/default.html'

def Quote(*args, **kwargs):
    warnings.warn(
        "The 'Quote' class was renamed 'QuotePlugin' and will be removed in a future version of ICEkit",
        DeprecationWarning )
    return QuotePlugin(*args, **kwargs)
