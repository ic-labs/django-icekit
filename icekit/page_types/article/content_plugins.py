from fluent_contents.extensions import plugin_pool
from icekit.models import LinkPlugin
from .import models

@plugin_pool.register
class ArticleLinkPlugin(LinkPlugin):
    model = models.ArticleLink
