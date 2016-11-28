"""
Model declaration for the `author` app.
"""
import re
try:
    from urlparse import urljoin
except ImportError:
    from urllib.parse import urljoin

from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import PlaceholderField
from icekit.models import ICEkitContentsMixin

from icekit.content_collections.abstract_models import AbstractListingPage, \
    AbstractCollectedContent
from icekit.validators import RelativeURLValidator


class AuthorListing(AbstractListingPage):
    """
    Author listing page to be mounted in fluent pages page tree.
    """
    class Meta:
        verbose_name = 'Author listing'

    def get_items_to_list(self, request):
        """
        :return: all published authors
        """
        return Author.objects.published()

    def get_items_to_mount(self, request):
        """
        :return: all authors that can be viewed by the current user
        """
        return Author.objects.visible()

    class Meta:
        db_table = "icekit_authorlisting"


@python_2_unicode_compatible
class Author(AbstractCollectedContent, ICEkitContentsMixin):
    """
    An author model for use with article pages and assigning attribution.
    """
    given_names = models.CharField(
        max_length=255,
    )

    family_name = models.CharField(
        max_length=255,
        blank=True,
    )

    slug = models.SlugField(max_length=255)

    portrait = models.ForeignKey(
        'icekit_plugins_image.Image',
        blank=True,
        null=True,
        on_delete=models.SET_NULL,
    )

    url = models.CharField(
        max_length=255,
        blank=True,
        help_text=_('The URL for the authors website.'),
        validators=[RelativeURLValidator(), ]
    )

    oneliner = models.CharField(
        max_length=255,
        blank=True,
        help_text=_('An introduction about the author used on list pages.')
    )

    content = PlaceholderField(
        'author_content'
    )

    def __str__(self):
        return self.title

    @property
    def title(self):
        return " ".join((self.given_names, self.family_name))

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

    @property
    def parent(self):
        try:
            return AuthorListing.objects.draft()[0]
        except IndexError:
            raise IndexError("You need to create a Author Listing Page")

    def get_absolute_url(self):
        parent_url = self.parent.get_absolute_url()
        return urljoin(parent_url, self.slug + "/")

    def get_layout_template_name(self):
        return "icekit_authors/detail.html"

    def get_list_image(self):
        if self.portrait:
            return self.portrait.image

    class Meta:
        ordering = ('family_name', 'given_names', )
