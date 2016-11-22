import os
from django.core.urlresolvers import NoReverseMatch
from fluent_contents.models import ContentItem
from fluent_pages.urlresolvers import app_reverse, PageTypeNotMounted
from icekit.publishing.models import PublishingModel
from timezone import timezone
from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _

from icekit.content_collections.abstract_models import AbstractCollectedContent, \
    TitleSlugMixin, AbstractListingPage
from icekit.mixins import FluentFieldsMixin




@python_2_unicode_compatible
class ContactPerson(models.Model):
    name = models.CharField(max_length=255)
    title = models.CharField(max_length=255, blank=True)
    phone = models.CharField(max_length=255, blank=True)
    email = models.EmailField(max_length=255, blank=True)

    def __str__(self):
        return "{} ({})".format(self.name, self.title)

    class Meta:
        verbose_name_plural = "Contact people"


@python_2_unicode_compatible
class ContactPersonItem(ContentItem):
    """
    A content item that links to a Press Contact.
    """
    contact = models.ForeignKey(ContactPerson)

    help_text = \
        'A content plugin that allows you to add press contact information.'

    class Meta:
        verbose_name = _('Contact Person')

    def __str__(self):
        return str(self.contact)
