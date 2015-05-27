from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class DigitalGardenImagePlugin(ContentPlugin):
    model = models.DigitalGardenImageItem
    category = _('Media')
    render_template = 'icekit/plugins/digital_garden_image/default.html'
