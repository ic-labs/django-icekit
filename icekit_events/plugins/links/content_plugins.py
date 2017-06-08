from copy import deepcopy
from icekit.plugins.links.abstract_models import LinkPlugin
from . import models
from fluent_contents.extensions import plugin_pool


@plugin_pool.register
class EventLinkPlugin(LinkPlugin):
    model = models.EventLink
    fieldsets = deepcopy(LinkPlugin.fieldsets)
    fieldsets[1][1]['fields'] += ("include_even_when_finished",)
    render_template = 'plugins/link/event.html'
