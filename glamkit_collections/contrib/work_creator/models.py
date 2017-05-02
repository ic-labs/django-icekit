from django.core.urlresolvers import reverse
from django.template.defaultfilters import pluralize
from django_countries.fields import CountryField
from glamkit_collections.contrib.work_creator.managers import \
    WorkCreatorQuerySet, WorkImageQuerySet
from icekit.content_collections.abstract_models import TitleSlugMixin, \
    PluralTitleSlugMixin
from icekit.mixins import FluentFieldsMixin, ListableMixin
from icekit.plugins.image.abstract_models import ImageLinkMixin
from icekit.models import ICEkitContentsMixin
from polymorphic.models import PolymorphicModel
from django.db import models


class CreatorBase(
    PolymorphicModel,
    FluentFieldsMixin,
    ICEkitContentsMixin,
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
        on_delete=models.SET_NULL,
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
        ordering = ('name_sort', 'slug', 'publishing_is_draft')
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

        Normal behaviour is to return published works if possible
        AND draft works if they haven't been published. Draft works are
        to be shown without links.
        """
        qs = self.get_draft().works
        # only return works that don't have an equivalent published version
        # (ie items that are themselves published, and unpublished drafts)
        return qs.filter(publishing_linked=None)

    def get_works_count(self):
        """To be used in Admin listings"""
        return self.get_works().count()

    def get_hero_image(self):
        if self.portrait:
            return self.portrait

    def get_list_image(self):
        if self.portrait:
            return self.list_image or self.portrait.image

    def get_title(self):
        return self.name_display

    def get_type(self):
        return "creator"

    def get_roles(self):
        """Return the m2m relations connecting me to works"""
        work_ids = self.get_works().values_list('id', flat=True)
        return self.works.through.objects.filter(
            creator=self.get_draft(),
            work_id__in=work_ids,
        ).select_related('role')

    def get_primary_roles(self):
        """Return the m2m relations connecting me to works as primary creator"""
        return self.get_roles().filter(is_primary=True)


class WorkBase(
    PolymorphicModel,
    FluentFieldsMixin,
    ICEkitContentsMixin,
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
        ordering = ('slug', 'publishing_is_draft', )
        unique_together = ('slug', 'publishing_is_draft',)

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
        :return: The creaors that should be presented as visible on the front
        end.

        Normal behaviour is to return published creators if possible
        AND draft creators if they haven't been published. Draft creators are
        to be shown without links.
        """
        qs = self.get_draft().creators
        # only return creators that don't have an equivalent published version
        # (ie items that are themselves published, and unpublished drafts)
        return qs.filter(publishing_linked=None)

    def get_roles(self):
        """
        Return the m2m relations connecting me to creators.

        There's some publishing-related complexity here. The role relations
        (self.creators.through) connect to draft objects, which then need to
        be modified to point to visible() objects.

        """

        creator_ids = self.get_creators().values_list('id', flat=True)

        return self.creators.through.objects.filter(
            work=self.get_draft(),
            creator_id__in=creator_ids,
        ).select_related('role')

    def get_primary_roles(self):
        """Return the m2m relations connecting me to creators as primary creator"""
        return self.get_roles().filter(is_primary=True)


class Role(PluralTitleSlugMixin):
    past_tense = models.CharField(max_length=255, help_text="If the role is 'foundry', the past tense should be 'forged'. Use lower case.")


class WorkCreator(models.Model):
    creator = models.ForeignKey(CreatorBase, on_delete=models.CASCADE)
    work = models.ForeignKey(WorkBase, on_delete=models.CASCADE)
    role = models.ForeignKey(Role, blank=True, null=True, on_delete=models.SET_NULL,)
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
    work = models.ForeignKey(WorkBase, on_delete=models.CASCADE)
    type = models.ForeignKey(WorkImageType, blank=True, null=True, on_delete=models.SET_NULL)
    order = models.PositiveIntegerField(
        help_text="Which order to show this image in the set of images.",
        default=0)

    objects = WorkImageQuerySet.as_manager()

    class Meta:
        ordering = ('order',)
        verbose_name = "Image"
