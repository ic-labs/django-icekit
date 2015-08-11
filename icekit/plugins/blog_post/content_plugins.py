"""
Definition of the plugin.
"""
from django.apps import apps
from django.conf import settings
from django.db.models.loading import get_model
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool


default_blog_model = 'blog_tools.BlogPost'
icekit_blog_model = getattr(settings, 'ICEKIT_BLOG_MODEL', default_blog_model)
BLOG_MODEL = apps.get_model(*icekit_blog_model.rsplit('.', 1))

if icekit_blog_model != default_blog_model:
    @plugin_pool.register
    class BlogPostPlugin(ContentPlugin):
        model = get_model(getattr(settings, 'ICEKIT_BLOG_CONTENT_ITEM', 'blog_post.PostItem'))
        category = _('Blog')
        render_template = 'icekit/plugins/post/default.html'
        raw_id_fields = ['post', ]
