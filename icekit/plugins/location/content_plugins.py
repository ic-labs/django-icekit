"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class LocationPlugin(ContentPlugin):
    model = models.LocationItem
    category = _('Assets')
    render_template = 'icekit/plugins/location/item.html'
    raw_id_fields = ['location', ]
