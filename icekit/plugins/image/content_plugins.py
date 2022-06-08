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
    category = _('Assets')
    raw_id_fields = ['image', ]
    fieldsets =  (
        (None, {
            'fields': (
                'image',
                # 'rendered_caption',
            )
        }),
        (None, {
            'fields': (
                'carousel_cta_url',
                'carousel_cta_text_label',
            )
        }),
        ('Caption', {
            'classes': ('collapse',),
            'fields': (
                ('show_title', 'show_caption'),
                'title_override',
                'caption_override',
            )
        })
    )

    def get_render_template(self, request, instance, **kwargs):
        opts = type(instance.parent)._meta
        template = loader.select_template(
            [
                'icekit/plugins/image/%s_%s.html' % (opts.app_label, opts.model_name),
                'icekit/plugins/image/%s.html' % opts.app_label,
                'icekit/plugins/image/default.html'
            ]
        )
        # In Django >= 1.8 `select_template` returns an instance of
        # `django.template.backends.django.Template` if the template exists. To obtain the
        # `django.template.base.Template` object we need to get the `template` attribute on it.
        # Previous versions of Django return a `django.template.base.Template` object.
        if hasattr(template, 'template'):
            template = template.template
        return template.name
