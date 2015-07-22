"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class FAQ(ContentPlugin):
    model = models.FAQItem
    category = _('Text')
    render_template = 'icekit/plugins/faq/default.html'
