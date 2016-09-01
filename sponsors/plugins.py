# from django.db import models
# from django.utils.encoding import python_2_unicode_compatible
# from django.utils.translation import ugettext_lazy as _
# from fluent_contents.models import ContentItem
# from fluent_contents.extensions import plugin_pool, ContentPlugin
# from .models import PressContact
#
#
# @python_2_unicode_compatible
# class ContactItem(ContentItem):
#     """
#     Promotional item for a Contact.
#     """
#     contact = models.ForeignKey(PressContact)
#
#     help_me_out_here = \
#         'A content plugin that allows you to add contact information.'
#
#     class Meta:
#         verbose_name = _('Contact Item')
#
#     def __str__(self):
#         return str(self.contact)
#
#
# @plugin_pool.register
# class ContactItemPlugin(ContentPlugin):
#     model = ContactItem
#     render_template = 'icekit_press_releases/press_contact_item/contact.html'
#     category = _('Press Releases')
