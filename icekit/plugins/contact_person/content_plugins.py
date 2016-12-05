from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import plugin_pool, ContentPlugin
from .models import ContactPersonItem


@plugin_pool.register
class ContactPersonPlugin(ContentPlugin):
    model = ContactPersonItem
    raw_id_fields = ('contact', )
    render_template = 'icekit/plugins/contact_person/default.html'
    category = _('Assets')
