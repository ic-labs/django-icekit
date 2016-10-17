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


class PressReleaseListing(AbstractListingPage):
    class Meta:
        verbose_name = "Press release listing"

    def get_items_to_list(self, request): # items that are shown in the listing
        return PressRelease.objects.published()

    def get_items_to_mount(self, request): # items that can be previewed
        return PressRelease.objects.visible()



@python_2_unicode_compatible
class PressContact(models.Model):
    name = models.CharField(max_length=255)
    title = models.CharField(max_length=255, blank=True)
    phone = models.CharField(max_length=255, blank=True)
    email = models.EmailField(max_length=255, blank=True)

    def __str__(self):
        return "{} ({})".format(self.name, self.title)


@python_2_unicode_compatible
class PressReleaseCategory(models.Model):
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "press release categories"

python_2_unicode_compatible
class PressRelease(PublishingModel, AbstractCollectedContent, TitleSlugMixin, FluentFieldsMixin):

    category = models.ForeignKey(
        PressReleaseCategory, null=True, blank=True)

    print_version = models.FileField(
        upload_to='press-releases/downloads/',
        null=True,
        blank=True
    )

    # TODO: consider intersection with publishing fields - are both necessary?
    created = models.DateTimeField(
        default=timezone.now, db_index=True, editable=False)
    modified = models.DateTimeField(blank=True, null=True, db_index=True)
    released = models.DateTimeField(blank=True, null=True, db_index=True)

    class Meta:
        ordering = ('-released', )

    def __str__(self):
        return self.title

    @property
    def download_extension(self): # TODO: make this a template tag
        name, extension = os.path.splitext(self.print_version.name)
        return extension[1:]

    @property
    def parent(self):
        try:
            return PressReleaseListing.objects.draft()[0]
        except IndexError:
            raise IndexError("You need to create a Press Release Listing Page")


@python_2_unicode_compatible
class ContactItem(ContentItem):
    """
    A content item that links to a Press Contact.
    """
    contact = models.ForeignKey(PressContact)

    help_text = \
        'A content plugin that allows you to add press contact information.'

    class Meta:
        verbose_name = _('Contact Item')

    def __str__(self):
        return str(self.contact)
