"""
Definition of the plugin.
"""
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import ContentPlugin, plugin_pool

from . import models


@plugin_pool.register
class BrightcovePlugin(ContentPlugin):
    model = models.BrightcoveItem
    category = _('Media')
    render_template = 'icekit/plugins/brightcove/default.html'

    class FrontendMedia:
        js = (
            # currently breaks on compression - include in base.html instead
            # '//admin.brightcove.com/js/BrightcoveExperiences.js',
        )
