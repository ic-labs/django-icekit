"""
Model declaration for the `author` app.
"""
import re
from django.core.urlresolvers import NoReverseMatch
from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import PluginHtmlField
from fluent_contents.models import PlaceholderField
from fluent_pages.urlresolvers import app_reverse, PageTypeNotMounted
from icekit.validators import RelativeURLValidator
from icekit.publishing.models import PublishingModel


@python_2_unicode_compatible
class Author(PublishingModel):
    """
    An author model for use with article pages and assigning attribution.
    """
    given_name = models.CharField(
        max_length=255,
    )

    family_name = models.CharField(
        max_length=255,
        blank=True,
    )

    slug = models.SlugField()

    portrait = models.ForeignKey(
        'icekit_plugins_image.Image',
        blank=True,
        null=True,
    )

    url = models.CharField(
        max_length=255,
        blank=True,
        help_text=_('The URL for the authors website.'),
        validators=[RelativeURLValidator(), ]
    )

    introduction = PluginHtmlField(
        _('introduction'),
        help_text=_('An introduction about the author used on list pages.')
    )

    content = PlaceholderField(
        'author_content'
    )

    def __str__(self):
        return self.get_full_name()

    def title(self):
        return self.get_full_name()

    def get_full_name(self):
        """
        Obtain the full name for an author.
        :return: String.
        """
        full_name = u'%s %s' % (self.given_name, self.family_name)
        return full_name.strip()

    def get_absolute_url(self):
        """
        Return the absolute URL for the author.

        If there is no Authors Page available it will return a static URL
        (which has to be hooked up automatically).

        :return: String.
        """

        try:
            # `app_reverse` is used here for compatibility with mounted
            # `fluent_pages` URL structures.
            return app_reverse(
                'author-detail',
                kwargs={'slug': self.slug},
                ignore_multiple=True
            )
        except (PageTypeNotMounted, NoReverseMatch):
            return "/authors/%s" % self.slug


    @property
    def url_link_text(self):
        """
        Return a cleaned-up version of the URL of an author's website,
        to use as a label for a link.

        TODO: make a template filter

        :return: String.
        """
        url_link_text = re.sub('^https?://', '', self.url)
        return url_link_text.strip('/')

    def contributions(self):
        """
        :return: List of all content that should show for this author.
        """
        return []

    class Meta:
        ordering = ('family_name', )
