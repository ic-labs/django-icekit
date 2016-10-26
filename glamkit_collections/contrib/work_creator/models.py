from django_countries.fields import CountryField
from icekit.content_collections.abstract_models import TitleSlugMixin
from icekit.mixins import FluentFieldsMixin, ListableMixin
from icekit.publishing.models import PublishingModel
from polymorphic.models import PolymorphicModel
from django.db import models
from django.utils.translation import ugettext_lazy as _


class CreatorBase(
    PolymorphicModel,
    FluentFieldsMixin,
    PublishingModel,
    ListableMixin,
):
    name_display = models.CharField(
        max_length=255,
        help_text='The commonly known or generally recognized name of the '
                  'creator, for display, publication and reproduction purposes, '
                  'e.g., "Rembrandt" or "Guercino" as opposed to the full name '
                  '"Rembrandt Harmenszoon Van Rijn" or "Giovanni Francesco '
                  'Barbieri."'
    )

    #for URLs
    slug = models.CharField(
        max_length=255,
        db_index=True,
    )  # Alt slug redirects to it.
    alt_slug = models.SlugField(
        max_length=255,
        blank=True,
        db_index=True,
    )   # use unidecode + slugify for alt slug.
    # Alt slug matches should redirect to the canonical view.
    portrait = models.ForeignKey(
        'icekit_plugins_image.Image',
        blank=True,
        null=True,
    )
    website = models.CharField(
        blank=True,
        max_length=255,
    )
    wikipedia_link = models.URLField(blank=True, help_text="e.g. 'https://en.wikipedia.org/wiki/Pablo_Picasso'")

    admin_notes = models.TextField(blank=True)

    name_sort = models.CharField(
        max_length=255,
        help_text='For searching and organizing, the name or sequence of names '
                  'which determines the position of the creator in the list of '
                  'creators, so that he or she may be found where expected, '
                  'e.g. "Rembrandt" under "R" or "Guercino" under "G"'
    )

    class Meta:
        verbose_name = "creator"
        ordering = ('name_sort', )
        unique_together = ('slug', 'publishing_is_draft',)

    def __unicode__(self):
        return self.name_display

    def get_public_works(self):
        return self.works.all().published()

    def get_works_count(self):
        return self.works.count()

    def get_public_works_count(self):
        return self.get_public_works().count()


class WorkBase(
    PolymorphicModel,
    FluentFieldsMixin,
    PublishingModel,
    ListableMixin,
):
    # meta
    slug = models.CharField(max_length=255, db_index=True)
    # using accession number (URL-encoded) for canonical slug
    alt_slug = models.SlugField(max_length=255, blank=True, db_index=True)
    # using slugified, no-hyphens. Alt slug matches should redirect to the
    # canonical view.

    # what's it called
    title = models.CharField(
        max_length=255,
        help_text='The official title of this object. Includes series title '
                  'when appropriate.'
    )

    # who made it
    creators = models.ManyToManyField(
        'CreatorBase', through='WorkCreator', related_name='works'
    )

    date_display = models.CharField(
        "Date (display)",
        blank=True,
        max_length=255,
        help_text='Displays date as formatted for labels and reports, rather '
                  'than sorting.'
    )  # used on 'Explore Modern Art' 53841 records
    date_edtf = models.CharField(
        "Date (EDTF)",
        blank=True,
        null=True,
        max_length=64,
        help_text="an <a href='http://www.loc.gov/standards/datetime/"
                  "implementations.html'>EDTF</a>-formatted "
                  "date, as best as we could parse from the display date, e.g. "
                  "'1855/1860-06-04'",
    )

    # where was it made
    origin_continent = models.CharField(
        blank=True,
        max_length=255)
    origin_country = CountryField(blank=True)
    origin_state_province = models.CharField(
        blank=True,
        max_length=255)
    origin_city = models.CharField(
        blank=True,
        max_length=255)
    origin_neighborhood = models.CharField(
        blank=True,
        max_length=255)
    origin_colloquial = models.CharField(
        blank=True,
        max_length=255,
        help_text='The colloquial or historical name of the place at the time '
                  'of the object\'s creation, e.g., "East Bay"'
    )

    credit_line = models.TextField(
        blank=True,
        help_text="A formal public credit statement about a transfer of "
                  "ownership, acquisition, source, or sponsorship of an "
                  "item suitable for use in a display, label or publication"
                  # "The full text of lengthy credit statements may be "
                  # "accessed by visitors to the collection through the "
                  # "scrolling list of Notes & Histories on page 4 of the "
                  # "Object Info layout."
    )


    thumbnail_override = models.ImageField(
        blank=True,
        null=True,
        help_text=_(
            "An optional override to use when the work is displayed at thumbnail dimensions"
        ),
    )

    # how we got it
    accession_number = models.CharField(
        blank=True,
        max_length=255,
        help_text="The five components of the Accession number concatenated "
                  " in a single string for efficiency of display and retrieval."
    )
    department = models.CharField(
        blank=True,
        max_length=255,
        help_text='The curatorial unit responsible for the object, '
                  'e.g., "Western Painting."'
    )

    website = models.URLField(
        help_text="A URL at which to view this work, if available online",
        blank=True,
    )

    wikipedia_link = models.URLField(blank=True, help_text="e.g. 'https://en.wikipedia.org/wiki/Beauty_and_the_Beast_(2014_film)'")

    admin_notes = models.TextField(blank=True)

    class Meta:
        verbose_name = "work"
        unique_together = ('slug', 'publishing_is_draft',)
        # ordering= ("date_sort_latest", )

    def __unicode__(self):
        if self.date_display:
            return u"%s (%s)" % (self.title, self.date_display)
        return self.title


    # def public_images(self):
    #     # using Optimizing manager will prefetch a list.
    #     if hasattr(self, 'prefetched_public_images'):
    #         return self.prefetched_public_images
    #
    #     queryset = self.images.filter(self.PUBLIC_IMAGE_QS).order_by_view()
    #     return queryset
    #
    # def get_hero_image(self):
    #     if not hasattr(self, "_hero_image"):
    #         try:
    #             self._hero_image = self.public_images()[0]
    #         except IndexError:
    #             self._hero_image = None
    #     return self._hero_image
    #
    # def get_thumbnail_image(self):
    #     """
    #     Returns the most appropriate ImageField for use as an artwork's thumbnail
    #     """
    #     if self.thumbnail_override:
    #         return self.thumbnail_override.image
    #     if self.hero_image:
    #         return self.hero_image.downloaded_image



class Role(TitleSlugMixin):
    past_tense = models.CharField(max_length=255, help_text="If the role is 'foundry', the past tense should be 'forged'. Use lower case.")

class WorkCreator(models.Model):
    creator = models.ForeignKey(CreatorBase)
    work = models.ForeignKey(WorkBase)

    order = models.PositiveIntegerField(help_text="Which order to show this creator in the list of all creators")
    role = models.ForeignKey(Role, blank=True, null=True)
    is_primary = models.BooleanField(default=True)

    class Meta:
        unique_together = ('creator', 'work', 'role')
        ordering = ("order", )

    def __unicode__(self):
        return "%s, %s by %s" % (unicode(self.work), self.role.past_tense, unicode(self.creator))