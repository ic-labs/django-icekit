from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import plugin_pool, ContentPlugin

from . import models


@plugin_pool.register
class PageAnchorListPlugin(ContentPlugin):
    model = models.PageAnchorListItem
    render_template = 'icekit/plugins/page_anchor_list/default.html'
    category = _('Advanced')
