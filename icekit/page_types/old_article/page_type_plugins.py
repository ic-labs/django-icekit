from fluent_pages.extensions import page_type_pool
from icekit.plugins import ICEkitFluentContentsPagePlugin

from . import admin, models


# Register this plugin to the page plugin pool.
@page_type_pool.register
class ArticlePagePlugin(ICEkitFluentContentsPagePlugin):
    """
    ArticlePage implementation as a plugin for use with pages.
    """
    model = models.ArticlePage
    model_admin = admin.ArticlePageAdmin
    sort_priority = 10

    render_template = 'icekit/page_types/article/default.html'
