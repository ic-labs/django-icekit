from django.core.urlresolvers import reverse
from django_countries.fields import CountryField
from glamkit_collections.contrib.work_creator.managers import \
    WorkCreatorQuerySet, WorkImageQuerySet
from icekit.content_collections.abstract_models import TitleSlugMixin
from icekit.mixins import FluentFieldsMixin, ListableMixin
from icekit.plugins.image.abstract_models import ImageLinkMixin
from icekit.publishing.models import PublishingModel
from polymorphic.models import PolymorphicModel
from django.db import models


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
        ordering = ('name_sort', 'slug')
        unique_together = ('slug', 'publishing_is_draft',)

    def __unicode__(self):
        return self.name_display

    def get_absolute_url(self):
        return reverse("gk_collections_creator", kwargs={'slug' :self.slug})

    def get_works(self):
        """
        :return: The works that should be presented as visible on the front
        end. If self is draft, show visible related items. If self is
        published, show published related items.

        """

        # need to query the long way round as reverse relations don't get
        # the publishing attributes.
        qs = WorkBase.objects.filter(
                id__in=[x.pk for x in self.get_draft().works.all()])

        if self.is_draft:
            return qs.visible()
        else:
            return qs.published()

    def get_works_count(self):
        """To be used in Admin listings"""
        return self.get_works().count()

    def get_hero_image(self):
        if self.portrait:
            return self.portrait.image

    def get_title(self):
        return self.name_display

    def get_type(self):
        return "creator"

    def get_roles(self):
        """Return the m2m relations connecting me to works"""
        return self.works.through.objects.filter(creator=self).select_related('role')

    def get_primary_roles(self):
        """Return the m2m relations connecting me to works as primary creator"""
        return self.works.through.objects.filter(creator=self, is_primary=True).select_related('role')


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
    subtitle = models.CharField(max_length=511, blank=True)
    oneliner = models.CharField("One-liner", max_length=511, blank=True,
                                 help_text="A pithy description of the work")

    # who made it
    creators = models.ManyToManyField(
        'CreatorBase', through='WorkCreator', related_name='works'
    )

    date_display = models.CharField(
        "Date of creation (display)",
        blank=True,
        max_length=255,
        help_text='Displays date as formatted for labels and reports, rather '
                  'than sorting.'
    )  # used on 'Explore Modern Art' 53841 records
    date_edtf = models.CharField(
        "Date of creation (EDTF)",
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
    images = models.ManyToManyField('icekit_plugins_image.Image', through="WorkImage")

    class Meta:
        verbose_name = "work"
        unique_together = ('slug', 'publishing_is_draft',)
        # ordering= ("date_sort_latest", )

    def __unicode__(self):
        if self.date_display:
            return u"%s (%s)" % (self.title, self.date_display)
        return self.title

    def get_absolute_url(self):
        return reverse("gk_collections_work", kwargs={'slug' :self.slug})

    def get_images(self, **kwargs):
        # order images by the order given in WorkImage.
        return self.images.filter(**kwargs).order_by('workimage')

    def get_hero_image(self):
        if not hasattr(self, "_hero_image"):
            try:
                self._hero_image = self.get_images()[0]
            except IndexError:
                self._hero_image = None
        if self._hero_image:
            return self._hero_image

    def get_subtitle(self):
        return self.subtitle

    def get_oneliner(self):
        return self.oneliner

    def get_type(self):
        return "work"

    def get_creators(self):
        """
        :return: The works that should be presented as visible on the front
        end. If self is draft, show visible related items. If self is
        published, show published related items.

        """
        qs = self.get_draft().creators
        if self.is_draft:
            return qs.visible()
        else:
            return qs.published()


    def get_roles(self):
        """Return the m2m relations connecting me to works"""
        return self.creators.through.objects.filter(
            work=self
        ).select_related('role')

    def get_primary_roles(self):
        """Return the m2m relations connecting me to works as primary creator"""
        return self.creators.through.objects.filter(
            work=self,
            is_primary=True
        ).select_related('role')


class Role(TitleSlugMixin):
    past_tense = models.CharField(max_length=255, help_text="If the role is 'foundry', the past tense should be 'forged'. Use lower case.")


class WorkCreator(models.Model):
    creator = models.ForeignKey(CreatorBase)
    work = models.ForeignKey(WorkBase)
    role = models.ForeignKey(Role, blank=True, null=True)
    is_primary = models.BooleanField("Primary?", default=True)
    order = models.PositiveIntegerField(help_text="Which order to show this creator in the list of creators.", default=0)

    objects = WorkCreatorQuerySet.as_manager()

    class Meta:
        unique_together = ('creator', 'work', 'role')
        ordering = ('order', '-is_primary')
        verbose_name = "Work-Creator relation"

    def __unicode__(self):
        if self.role:
            return "%s, %s by %s" % (unicode(self.work), self.role.past_tense, unicode(self.creator))
        else:
            return "%s, created by %s" % (unicode(self.work), unicode(self.creator))


class WorkImageType(TitleSlugMixin):
    class Meta:
        verbose_name = "Image type"


class WorkImage(ImageLinkMixin):
    work = models.ForeignKey(WorkBase)
    type = models.ForeignKey(WorkImageType, blank=True, null=True)
    order = models.PositiveIntegerField(
        help_text="Which order to show this image in the set of images.",
        default=0)

    objects = WorkImageQuerySet.as_manager()

    class Meta:
        ordering = ('order',)
        verbose_name = "Image"
