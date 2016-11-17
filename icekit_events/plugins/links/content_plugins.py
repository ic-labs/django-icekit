from icekit.plugins.links.abstract_models import LinkPlugin
from . import models
from fluent_contents.extensions import plugin_pool


@plugin_pool.register
class EventLinkPlugin(LinkPlugin):
    model = models.EventLink

