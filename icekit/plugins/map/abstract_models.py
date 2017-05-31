from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from fluent_contents.models import ContentItem
import bleach

MAP_EMBED_IFRAME_BLACKLISTED_PROPERTIES = (
    'width',
    'height',
)


def embed_code_allow_attributes(tag, name, value):
    return name not in MAP_EMBED_IFRAME_BLACKLISTED_PROPERTIES


@python_2_unicode_compatible
class AbstractMapItem(ContentItem):
    """
    Wraps google maps embed code and remove properties that will
    conflict with the front-end
    """
    _embed_code = models.TextField(
        verbose_name='Embed code',
        blank=False,
        help_text='Embed code sourced from Google Maps. '
                  'See <a href="https://support.google.com/maps/answer/144361">'
                  'https://support.google.com/maps/answer/144361</a>',
    )
    # Used to cache a cleaned version of `embed_code` after it has
    # been prepared for the front-end. Allow blank input to avoid
    # any edge-cases where the cleaned version may be empty
    _cleaned_embed_code = models.TextField(
        editable=False,
        blank=True,
    )

    class Meta:
        abstract = True
        verbose_name = 'Google Map'

    def __str__(self):
        return self._embed_code

    def save(self, *args, **kwargs):
        self._cleaned_embed_code = bleach.clean(
            self._embed_code,
            tags=['iframe'],  # Allowed tags
            attributes=embed_code_allow_attributes,
            styles=['border']
        )

        return super(AbstractMapItem, self).save(*args, **kwargs)

    def get_embed_code(self):
        return self._cleaned_embed_code
