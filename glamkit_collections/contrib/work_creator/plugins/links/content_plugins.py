from icekit.plugins.links.abstract_models import LinkPlugin
from . import models
from fluent_contents.extensions import plugin_pool


@plugin_pool.register
class WorkLinkPlugin(LinkPlugin):
    model = models.WorkLink


@plugin_pool.register
class CreatorLinkPlugin(LinkPlugin):
    model = models.CreatorLink


