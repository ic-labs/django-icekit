"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class BlogPlugin(ContentPlugin):
    model = models.PostItem
    category = _('Blog')
    render_template = 'icekit/plugins/post/default.html'
    raw_id_fields = ['post', ]
