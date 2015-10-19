"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class FormPlugin(ContentPlugin):
    model = models.FormItem
    category = _('Forms')
    render_template = 'icekit/plugins/reusable_form/default.html'
    raw_id_fields = ['form', ]
    cache_output = False
