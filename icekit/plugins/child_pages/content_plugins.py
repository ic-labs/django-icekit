"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class ChildPagesPlugin(ContentPlugin):
    model = models.ChildPageItem
    category = _('Pages')
    render_template = 'icekit/plugins/child_pages/default.html'
