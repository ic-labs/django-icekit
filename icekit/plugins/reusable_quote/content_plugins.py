"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class ReusableQuote(ContentPlugin):
    model = models.ReusableQuoteItem
    category = _('Text')
    render_template = 'icekit/plugins/reusable_quote/default.html'
