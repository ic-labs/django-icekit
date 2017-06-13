from copy import deepcopy
from icekit.plugins.links.abstract_models import LinkPlugin
from . import models
from fluent_contents.extensions import plugin_pool

@plugin_pool.register
class PageLinkPlugin(LinkPlugin):
    model = models.PageLink


@plugin_pool.register
class ArticleLinkPlugin(LinkPlugin):
    model = models.ArticleLink


@plugin_pool.register
class AuthorLinkPlugin(LinkPlugin):
    model = models.AuthorLink
    fieldsets = deepcopy(LinkPlugin.fieldsets)
    fieldsets[1][1]['fields'] += (
        "exclude_from_contributions",
        "exclude_from_authorship",
    )

