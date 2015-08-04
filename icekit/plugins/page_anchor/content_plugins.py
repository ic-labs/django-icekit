from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import plugin_pool, ContentPlugin

from . import models


@plugin_pool.register
class PageAnchorPlugin(ContentPlugin):
    model = models.PageAnchorItem
    render_template = 'icekit/plugins/page_anchor/default.html'
    category = _('Advanced')
