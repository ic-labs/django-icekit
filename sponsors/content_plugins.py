from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import plugin_pool, ContentPlugin
from . import models


@plugin_pool.register
class BeginSponsorBlockPlugin(ContentPlugin):
    model = models.BeginSponsorBlockItem
    render_template = 'sfmoma/plugins/sponsor_block/begin.html'
    category = _('Sponsorship')

@plugin_pool.register
class EndSponsorBlockPlugin(ContentPlugin):
    model = models.EndSponsorBlockItem
    render_template = 'sfmoma/plugins/sponsor_block/end.html'
    category = _('Sponsorship')


@plugin_pool.register
class SponsorPromoPlugin(ContentPlugin):
    model = models.SponsorPromoItem
    render_template = 'sfmoma/plugins/sponsor_block/sponsor.html'
    category = _('Sponsorship')
    raw_id_fields = ['sponsor', ]
