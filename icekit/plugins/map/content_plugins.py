from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import plugin_pool, ContentPlugin

from . import models


@plugin_pool.register
class MapPlugin(ContentPlugin):
    model = models.MapItem
    render_template = 'icekit/plugins/map/embed.html'
    category = _('Media')

    def render(self, request, instance, **kwargs):
        instance.parse_share_url()
        return super(MapPlugin, self).render(request, instance, **kwargs)
