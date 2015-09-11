"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from django.template import loader
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class ImagePlugin(ContentPlugin):
    model = models.ImageItem
    category = _('Image')
    raw_id_fields = ['image', ]

    def get_render_template(self, request, instance, **kwargs):
        template = loader.select_template([
            'icekit/plugins/image/%s_%s.html' % (
                type(instance.parent)._meta.app_label,
                type(instance.parent)._meta.model_name
            ),
            'icekit/plugins/image/%s.html' % type(
                instance.parent)._meta.app_label,
            'icekit/plugins/image/default.html'])
        return template.name
