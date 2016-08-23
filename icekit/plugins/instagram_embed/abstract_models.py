import json
import requests
from django.core import exceptions
from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.safestring import mark_safe
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class AbstractInstagramEmbedItem(ContentItem):
    """
    An embeded instagram image.
    """
    url = models.URLField(verbose_name=_('URL'))

    # Data return from OEmbed API call.
    provider_url = models.CharField(max_length=512, blank=True)
    media_id = models.CharField(max_length=255, blank=True)
    author_name = models.CharField(max_length=255, blank=True)
    height = models.PositiveIntegerField(blank=True, null=True)
    width = models.PositiveIntegerField(blank=True, null=True)
    thumbnail_url = models.CharField(max_length=255, blank=True)
    thumbnail_width = models.PositiveIntegerField(blank=True, null=True)
    thumbnail_height = models.PositiveIntegerField(blank=True, null=True)
    provider_name = models.CharField(max_length=255, blank=True)
    title = models.CharField(max_length=512, blank=True)
    html = models.TextField(blank=True)
    version = models.CharField(max_length=20, blank=True)
    author_url = models.CharField(max_length=255, blank=True)
    author_id = models.PositiveIntegerField(blank=True, null=True)
    type = models.CharField(max_length=50, blank=True)

    class Meta:
        abstract = True
        verbose_name = _('Instagram Embed')

    def __str__(self):
        return 'Instagram Embed: %s' % self.url

    def clean(self, *args, **kwargs):
        """
        Prefetch instagram data and clean it.
        """
        # Get the instagram data.
        instagram_data = self.fetch_instagram_data()

        # If a dict is returned assume it is the JSON data returned from instagram.
        if isinstance(instagram_data, dict):
            # Set each of the data attributes.
            for key in instagram_data.keys():
                setattr(self, key, instagram_data[key])
        else:
            raise exceptions.ValidationError(instagram_data)

        super(AbstractInstagramEmbedItem, self).clean(*args, **kwargs)

    def fetch_instagram_data(self):
        """
        Get the instagram data for the url.

        :return: Dict of data if successful or String if error.
        """
        # Don't fetch content from Instgram API if we have an empty URL, which
        # can happen if a user enters an invalid URL in the admin form.
        if not self.url:
            return ''
        r = requests.get('http://api.instagram.com/publicapi/oembed/?url=%s' % self.url)
        if r.status_code is 200:
            return json.loads(r.content.decode())
        return r.content

    def get_thumbnail(self):
        """
        Get the image thumbnail url if it exists.

        :return: String.
        """
        if self.thumbnail_url:
            return self.thumbnail_url
        return ''

    def get_default_embed(self):
        """
        Get the default embed if it exists.

        :return: HTML String marked safe.
        """
        if self.html:
            return mark_safe(self.html)
        return ''
