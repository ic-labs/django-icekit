"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class FilePlugin(ContentPlugin):
    model = models.FileItem
    category = _('File')
    render_template = 'icekit/plugins/file/default.html'
    raw_id_fields = ['file', ]
