from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import plugin_pool, ContentPlugin

from . import models


@plugin_pool.register
class HorizontalRulePlugin(ContentPlugin):
    model = models.HorizontalRuleItem
    render_template = 'icekit/plugins/horizontal_rule/default.html'
    category = _('Text')
