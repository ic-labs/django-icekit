"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class ImageGalleryPlugin(ContentPlugin):
    model = models.ImageGalleryShowItem
    category = _('Assets')
    render_template = 'icekit/plugins/image_gallery/default.html'
    raw_id_fields = ['slide_show', ]
