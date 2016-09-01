import os
from django.core.urlresolvers import NoReverseMatch
from fluent_pages.urlresolvers import app_reverse, PageTypeNotMounted
from icekit.articles.abstract_models import PublishableArticle
from timezone import timezone
from django.db import models
from django.utils.encoding import python_2_unicode_compatible


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


class PressRelease(PublishableArticle):

    category = models.ForeignKey(
        PressReleaseCategory, null=True, blank=True)

    print_version = models.FileField(
        upload_to='press-releases/downloads/',
        null=True,
        blank=True
    )

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

    def get_absolute_url(self):
        """
        Return the absolute URL for the press-release page.

        If there is no URL pattern available it will return an empty
        string.

        :return: String.
        """
        try:
            # `app_reverse` is used here for compatibility with mounted
            # `fluent_pages` URL structures.
            return app_reverse(
                'press-release-detail',
                kwargs={'slug': -self.slug},
                ignore_multiple=True
            )
        except (PageTypeNotMounted, NoReverseMatch):
            return ''
