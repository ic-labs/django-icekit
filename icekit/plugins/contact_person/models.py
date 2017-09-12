from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _

from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class ContactPerson(models.Model):
    name = models.CharField(max_length=255)
    title = models.CharField(max_length=255, blank=True)
    phone_full = models.CharField("Phone number", max_length=255, blank=True, help_text="The full (international) phone number to dial, including the country code, e.g. '+61 123456789'")
    phone_display = models.CharField("Phone number to display", max_length=255, blank=True, help_text="The phone number to display, if different from above, e.g. '0123 456-789'")
    email = models.EmailField(max_length=255, blank=True)

    def __str__(self):
        if self.title:
            return u"{} ({})".format(self.name, self.title)
        return self.name

    class Meta:
        verbose_name_plural = "Contact people"


@python_2_unicode_compatible
class ContactPersonItem(ContentItem):
    """
    A content item that links to a Press Contact.
    """
    contact = models.ForeignKey(
        ContactPerson,
        on_delete=models.CASCADE,
    )

    help_text = \
        'A content plugin that allows you to add press contact information.'

    class Meta:
        verbose_name = _('Contact Person')

    def __str__(self):
        return unicode(self.contact)
