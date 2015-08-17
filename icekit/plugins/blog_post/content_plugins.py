"""
Definition of the plugin.
"""
from django.apps import apps
from django.conf import settings
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool


@plugin_pool.register
class BlogPostPlugin(ContentPlugin):
    model = apps.get_model(
        getattr(settings, 'ICEKIT_BLOG_CONTENT_ITEM', 'blog_tools.PostItem')
    )
    category = _('Blog')
    render_template = 'icekit/plugins/post/default.html'
    raw_id_fields = ['post', ]
