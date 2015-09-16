import re

from django.core import exceptions
from django.db import models
from django.utils.encoding import python_2_unicode_compatible

from fluent_contents.models import ContentItem

# This will likely have to be tended as GMaps will change their
#  Share URL format over time.
# See tests.py
DETAILED_SHARE_URL_REGEXP = re.compile(
    r'place\/((?P<name>.+)\/)?\@(?P<loc>.+)\/')
SHORTENED_SHARE_URL_REGEXP = re.compile(r'goo\.gl\/maps\/')
OTHER_SHARE_URL_REGEXP = re.compile(r'google\.com\/maps\/')


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
    loc = '0, 0'

    class Meta:
        abstract = True
        verbose_name = 'Google Map'

    def clean(self, *args, **kwargs):
        self.parse_share_url()
        super(AbstractMapItem, self).clean(*args, **kwargs)

    def parse_share_url(self):
        """Search the Share URL for place name and lat/lon coordinates."""
        share_url_str = str(self.share_url)
        detailed_result = DETAILED_SHARE_URL_REGEXP.search(share_url_str)
        if detailed_result and getattr(detailed_result, 'groupdict'):
            self.place_name = detailed_result.groupdict()['name']
            self.loc = detailed_result.groupdict()['loc']
        elif SHORTENED_SHARE_URL_REGEXP.search(share_url_str) \
                or OTHER_SHARE_URL_REGEXP.search(share_url_str):
            self.place_name = 'Unknown'
            self.loc = '0, 0'
        else:
            raise exceptions.ValidationError('Invalid map Share URL')

    def __str__(self):
        if self.place_name == 'Unknown':
            self.parse_share_url()
        return '%s @%s' % (self.place_name, self.loc)

    def save(self, *args, **kwargs):
        self.parse_share_url()

        return super(AbstractMapItem, self).save(*args, **kwargs)
