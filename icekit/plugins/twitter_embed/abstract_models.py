import json
import requests
from django.core import exceptions
from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.safestring import mark_safe
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class AbstractTwitterEmbedItem(ContentItem):
    """
    An embeded twitter tweet.
    """
    twitter_url = models.URLField(verbose_name=_('URL'))

    # Data return from OEmbed API call.
    url = models.CharField(max_length=512, blank=True)
    provider_url = models.CharField(max_length=512, blank=True)
    cache_age = models.CharField(max_length=255, blank=True)
    author_name = models.CharField(max_length=255, blank=True)
    height = models.PositiveIntegerField(blank=True, null=True)
    width = models.PositiveIntegerField(blank=True, null=True)
    provider_name = models.CharField(max_length=255, blank=True)
    version = models.CharField(max_length=20, blank=True)
    author_url = models.CharField(max_length=255, blank=True)
    type = models.CharField(max_length=50, blank=True)
    html = models.TextField(blank=True)

    class Meta:
        abstract = True
        verbose_name = _('Twitter Embed')

    def __str__(self):
        return 'Twitter Embed: %s' % self.twitter_url

    def clean(self, *args, **kwargs):
        """
        Prefetch twitter data and clean it.
        """
        # Get the twitter data.
        twitter_data = self.fetch_twitter_data()

        # If a dict is returned assume it is the JSON data returned from twitter.
        if isinstance(twitter_data, dict):
            if 'errors' in twitter_data.keys():
                raise exceptions.ValidationError(twitter_data['errors'][0]['message'])
            # Set each of the data attributes.
            for key in twitter_data.keys():
                setattr(self, key, twitter_data[key])
        else:
            raise exceptions.ValidationError(twitter_data)

        super(AbstractTwitterEmbedItem, self).clean(*args, **kwargs)

    def fetch_twitter_data(self):
        """
        Get the twitter data for the url.

        :return: Dict of data if successful or String if error.
        """
        r = requests.get('https://api.twitter.com/1/statuses/oembed.json?url=%s' % self.twitter_url)
        if r.status_code in [200, 404]:
            # Force the decode here for python-3 support..
            return json.loads(r.content.decode('utf-8'))
        return r.content

    def get_default_embed(self):
        """
        Get the default embed if it exists.

        :return: HTML String marked safe.
        """
        if self.html:
            return mark_safe(self.html)
        return ''
