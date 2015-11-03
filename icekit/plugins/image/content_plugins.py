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
        opts = type(instance.parent)._meta
        template = loader.select_template(
            [
                'icekit/plugins/image/%s_%s.html' % (opts.app_label, opts.model_name),
                'icekit/plugins/image/%s.html' % opts.app_label,
                'icekit/plugins/image/default.html'
            ]
        )
        return template.name
