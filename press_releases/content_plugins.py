from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import plugin_pool, ContentPlugin
from .models import ContactItem


@plugin_pool.register
class ContactItemPlugin(ContentPlugin):
    model = ContactItem
    render_template = 'icekit_press_releases/press_contact_item/contact.html'
    category = _('Press Releases')
