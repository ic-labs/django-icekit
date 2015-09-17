import re
try:
    from urllib import urlopen
except ImportError:  # Python 3
    from urllib.request import urlopen

from django.core import exceptions
from django.db import models
from django.utils.encoding import python_2_unicode_compatible

from fluent_contents.models import ContentItem

# This will likely have to be tended as GMaps will change their
#  Share URL format over time.
# See tests.py
DETAILED_SHARE_URL_REGEXP = re.compile(
    r'place\/((?P<name>.+)\/)?\@(?P<loc>.+)\/')
EDIT_OR_VIEW_SHARE_URL_REGEXP = re.compile(
    r'google\.com\/maps\/d\/(?P<replacable_path>.*(viewer|edit)\?)')
EMBED_SHARE_URL_REGEXP = re.compile(r'google\.com\/maps\/.+\/embed?')
SHORTENED_SHARE_URL_REGEXP = re.compile(r'goo\.gl\/maps\/')


@python_2_unicode_compatible
class AbstractMapItem(ContentItem):
    """
    Embeds a Google Map inside an iframe from the Share URL.

    Rather than store the width/height in the DB, update the template
    used or override with CSS.
    """
    share_url = models.URLField(
        help_text='Share URL sourced from Google Maps. '
                  'See https://support.google.com/maps/answer/144361?hl=en',
        verbose_name='Share URL',
        max_length=500,
    )

    place_name = 'Unknown'
    loc = ''

    class Meta:
        abstract = True
        verbose_name = 'Google Map'

    def clean(self, *args, **kwargs):
        self.parse_share_url()
        super(AbstractMapItem, self).clean(*args, **kwargs)

    def parse_share_url(self):
        """Search the Share URL for place name and lat/lon coordinates."""
        share_url_str = str(self.share_url)

        # Lookup original URL for shortened URLs
        if SHORTENED_SHARE_URL_REGEXP.search(share_url_str):
            try:
                result = urlopen(self.share_url)
                self.share_url = result.url
                share_url_str = str(self.share_url)
            except:
                pass

        result = DETAILED_SHARE_URL_REGEXP.search(share_url_str)
        # Parse location and lat/long from standard share URLs
        if result and getattr(result, 'groupdict'):
            self.place_name = result.groupdict()['name']
            self.loc = result.groupdict()['loc']
            return
        # Covnert viewer-style URLs to embed versions
        result = EDIT_OR_VIEW_SHARE_URL_REGEXP.search(share_url_str)
        if result and getattr(result, 'groupdict'):
            # Convert "viewer" URL to "embed" version, e.g.
            # https://www.google.com/maps/d/u/0/viewer?mid=zLFp8zmG_u7Y.kWM6FxvhXeUw
            # =>
            # https://www.google.com/maps/d/embed?mid=zLFp8zmG_u7Y.kWM6FxvhXeUw
            self.share_url = self.share_url.replace(
                result.groupdict()['replacable_path'], 'embed?')
            return
        # Accept embed-style URLs as-is
        if EMBED_SHARE_URL_REGEXP.search(share_url_str):
            self.place_name = 'Unknown'
            self.loc = ''
            return
        raise exceptions.ValidationError('Invalid map Share URL')

    def __str__(self):
        if self.place_name == 'Unknown':
            self.parse_share_url()
        return '%s @%s' % (self.place_name, self.loc)

    def save(self, *args, **kwargs):
        self.parse_share_url()

        return super(AbstractMapItem, self).save(*args, **kwargs)
