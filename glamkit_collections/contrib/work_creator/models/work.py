from django.db.models import Q
from django.template import Template, Context
from django.utils.translation import ugettext_lazy as _
from django.utils.safestring import mark_safe
from django.core.urlresolvers import reverse
from django.db import models
from icekit.abstract_models import FluentFieldsMixin, BoostedTermsMixin
from glamkit_collections.utils import grammatical_join


class WorkBase(FluentFieldsMixin, BoostedTermsMixin):

    PUBLIC_IMAGE_QS = Q(
        is_public=True,
    ) & ~Q(
        downloaded_image=""
    )

    is_ok_for_web = models.BooleanField(default=False)

    # meta
    slug = models.CharField(max_length=255, unique=True, db_index=True)
    # using accession number (URL-encoded) for canonical slug
    alt_slug = models.SlugField(max_length=255, unique=True, db_index=True)
    # using slugified, no-hyphens. Alt slug matches should redirect to the
    # canonical view.

    last_updated = models.DateTimeField(
        auto_now=True,
        help_text="Every shadow import updates this timestamp. This is used to determine which obsolete records to delete at the end of import."
    )

    # what's it called
    title_display = models.CharField(
        max_length=255,
        help_text='The official title of this object. Includes series title '
                  'when appropriate.'
    )  # used on 'Explore Modern Art'

    # who made it
    artists = models.ManyToManyField(
        'Artist', through='ArtworkArtist', related_name='artworks'
    )

    medium_display = models.CharField(
        blank=True,
        max_length=255,
        help_text='A display field for information concerning the '
                  'material/media & support of the object'
    )  # used on 'Explore Modern Art' 72214 records.


    date_display = models.CharField(
        blank=True,
        max_length=255,
        help_text='Displays date as formatted for labels and reports, rather '
                  'than sorting.'
    )  # used on 'Explore Modern Art' 53841 records
    date_edtf = models.CharField(
        blank=True,
        null=True,
        max_length=64,
        help_text="an <a href='http://www.loc.gov/standards/datetime/"
                  "implementations.html'>EDTF</a>-formatted "
                  "date, as best as we could parse from the display date, e.g. "
                  "'1855/1860-06-04'",
    )
    date_edtf_earliest = models.DateField(
        blank=True,
        null=True,
        help_text="if we found an EDTF-formatted date, this is the earliest "
                  "date the EDTF range might reasonably cover. If we don't "
                  "have a date, value is null. e.g. '1855-01-01'"
    )
    date_edtf_latest = models.DateField(
        blank=True,
        null=True,
        help_text="if we found an EDTF-formatted date, this is the latest date "
                  "the EDTF range might reasonably cover.  If we don't have a "
                  "date, value is null. e.g. '1860-06-04'"
    )
    date_sort_earliest = models.DateField(
        blank=True,
        null=True,
        help_text="Single ISO date to use for sorting. Think of this as the "
                  "'most obvious' date represented by EDTF, with unknown parts "
                  "assigned LOWEST values by default. Sorting by this value "
                  "will make imprecise dates appear BEFORE precise dates. Some "
                  "works have a manually-specified order, and that date "
                  "appears here instead. If we don't have a date, the minimum "
                  "date is used. e.g. '1855-01-01'"
    )
    date_sort_latest = models.DateField(
        blank=True,
        null=True,
        help_text="Single ISO date to use for sorting. Think of this as the "
                  "'most obvious' date represented by EDTF, with unknown parts "
                  "assigned HIGHEST values by default. Sorting by this value "
                  "will make imprecise dates appear AFTER precise dates. Some "
                  "works have a manually-specified order, and that date "
                  "appears here instead. If we don't have a date, the maximum "
                  "date is used. e.g. '1855-12-31'"
    )

    # where was it made
    origin_continent = models.CharField(
        blank=True,
        max_length=255)  # 10616. This is a mess - has all kinds of data, inc. countries.
    origin_country = models.CharField(
        blank=True,
        max_length=255)  # 11105
    origin_state_province = models.CharField(
        blank=True,
        max_length=255)  # 6613
    origin_city = models.CharField(
        blank=True,
        max_length=255)  # 5672
    origin_neighborhood = models.CharField(
        blank=True,
        max_length=255)  # 693
    origin_colloquial = models.CharField(
        blank=True,
        max_length=255,
        help_text='The colloquial or historical name of the place at the time '
                  'of the object\'s creation, e.g., "East Bay"'
    )  # 1100


    credit_line = models.TextField(
        blank=True,
        help_text="A formal public credit statement about a transfer of "
                  "ownership, acquisition, source, or sponsorship of an "
                  "item suitable for use in a display, label or publication"
                  # "The full text of lengthy credit statements may be "
                  # "accessed by visitors to the collection through the "
                  # "scrolling list of Notes & Histories on page 4 of the "
                  # "Object Info layout."
    )  # used on 'Explore Modern Art'. 68031 records.


    thumbnail_override = models.ForeignKey(
        'image.Image',
        blank=True,
        null=True,
        on_delete=models.SET_NULL,
        help_text=_("An optional override to use when the artwork is displayed at thumbnail dimensions"),
        related_name='%(app_label)s_%(class)s_related',
    )

    # how big is it
    dimensions_is_two_dimensional = models.BooleanField(
        blank=True,
        default=False,
        help_text="A flag for rapid categorization of the object as "
                  "essentially two-dimensional or three-dimensional. "
                  "Used when generating the Preview scale drawing."
    )  # true for 65788 works. False for 11355 works
    dimensions_display = models.CharField(
        blank=True,
        max_length=255,
        help_text='A display field that contains the dimensions of the object '
                  '- the Display Height, Width, and Depth.'
    )  # used on 'Explore Modern Art' 58387 records.
    dimensions_extent = models.CharField(
        blank=True,
        max_length=255,
        help_text='A field to record the extent of the object represented by '
                  'the dimensions in the object record, '
                  'e.g., "image (w/o frame)," "overall (incl. pedestal)."'
    )  # 17149 records
    dimensions_width_cm = models.FloatField(
        blank=True,
        null=True,
        help_text='The measurement of the object\'s width, in metres'
    )  # 50920
    dimensions_height_cm = models.FloatField(
        blank=True,
        null=True, help_text="ditto height"
    )  # 50946
    dimensions_depth_cm = models.FloatField(
         blank=True,
       null=True, help_text="ditto depth"
    )  # 7711 records
    dimensions_weight_kg = models.FloatField(
        blank=True,
        null=True,
        help_text="The measurement of the object\'s width, in kilograms"
    )  # 748 records

    # how we got it
    accession_number = models.CharField(
        max_length=255,
        help_text="The five components of the Accession number concatenated "
                  "in a single string for efficiency of display and retrieval."
    )  # used on 'Explore Modern Art'  # 77143 - that's all of them


    # where is it
    department = models.CharField(
        blank=True,
        max_length=255,
        help_text='The managerial unit responsible for the object, '
                  'e.g., "Western Painting."'
    )  # used on 'Explore Modern Art'.  # 63330 records (!)

    # meta
    created_date = models.DateField(
        help_text="The date the record was created."
    )
    modified_date = models.DateField(
        help_text="The date the record was last modified."
    )

    external_url = models.URLField(
        help_text="A URL at which to view this artwork, if available online",
        blank=True,
    )


    class Meta:
        abstract = True
        ordering= ("date_sort_latest", )

    def __unicode__(self):
        # tempted to use self.title_text, but risk recursion error
        return u"%s (%s)" % (self.title_full or self.title_display, self.date_display)

    def credit_display(self):
        return self.credit_line

    def public_images(self):
        # using Optimizing manager will prefetch a list.
        if hasattr(self, 'prefetched_public_images'):
            return self.prefetched_public_images

        queryset = self.images.filter(self.PUBLIC_IMAGE_QS).order_by_view()
        return queryset

    @property
    def hero_image(self):
        if not hasattr(self, "_hero_image"):
            try:
                self._hero_image = self.public_images()[0]
            except IndexError:
                self._hero_image = None
        return self._hero_image

    @property
    def admin_hero_image(self):
        """
        :return: An ArtworkImage representing the artwork for admin users.
        Public hero is preferred, otherwise the first nonpublic image.
        """
        try:
            return self.hero_image or self.images.all()[0]
        except IndexError:
            return None

    @property
    def thumbnail_image(self):
        """
        Returns the most appropriate ImageField for use as an artwork's thumbnail
        """
        if self.thumbnail_override:
            return self.thumbnail_override.image
        if self.hero_image:
            return self.hero_image.downloaded_image

    def get_absolute_url(self):
        return reverse('artwork', args=[self.slug])

    @property
    def artist_name_pairs(self):
        return [(a.name_display, a.name_sort) for a in self.primary_artists()]

    ### different sublists of creators
    def creators_with_role(self, role):
        if hasattr(self, 'prefetched_artworkartists'):
            paa = self.prefetched_artworkartists
            return [a.artist for a in paa if (a.role.lower() == role and a.artist.is_ok_for_web)]
        else:
            return [a.artist for a in self.artworkartist_set.filter(role__iexact=role, artist__is_ok_for_web=True)]


    def primary_artists(self):
        # returns the Artists with role = Primary - hopefully just one.
        # these are the artists to be used in the credit line
        # in etl, we ensured that every work had at least one.
        # implied order by 'ArtworkArtist.order'
        return self.creators_with_role("primary")

    def nonprimary_artists(self):
        # returns the Artists with role = ""
        return self.creators_with_role("")

    def primary_and_nonprimary_artists(self):
        # returns the Artists with role in "Primary" or "", with Primary coming first.
        return self.primary_artists() + self.nonprimary_artists()

    def non_artist_roles(self):
        # returns the ArtworkArtists with role not in (Primary, Artist).
        # this would be e.g. foundry page and ideally wouldn't have a URL.
        if hasattr(self, 'prefetched_artworkartists'):
            return filter(
                lambda a: (a.role != '') and (a.role.lower() != "primary") and a.artist.is_ok_for_web,
                self.prefetched_artworkartists
            )
        else:
            return self.artworkartist_set.filter(artist__is_ok_for_web=True).exclude(role="").exclude(role__iexact="primary") #implied order by 'ArtworkArtist.order'


    ### cleaned-up artist lists, titles and captions, for web and in plain text.

    def artists_text(self):
        return grammatical_join([a.name_display for a in self.primary_artists()])

    def artists_html(self):
        return mark_safe(grammatical_join([a.name_display_html() for a in self.primary_artists()]))

    def title_text(self):
        # ignoring self.title_short as it can have HTML tags
        return self.title_full or self.title_display

    def title_html(self):
        """
        Titles are <em> and sometimes have .noItalics in title_short.
        """
        return mark_safe(
            "<em>" + (self.title_short or self.title_text()) + "</em>"
        )

    def short_caption_text(self):
        t = Template("""{% spaceless %}
            {{ work.artists_text }}, {{ work.title_text }}{% if work.date_display %}, {{ work.date_display }}{% endif %}
        {% endspaceless %}""")
        c = Context({'work': self})

        return t.render(c)


    def short_caption_html(self, link_artists=True, show_date=True):
        t = Template("""
        	{% if link_artists %}{{ work.artists_html }}{% else %}{{ work.artists_text }}{% endif %},
			{{ work.title_html }}{% if work.date_display and show_date %}, {{ work.date_display }}{% endif %}
        """)
        c = Context({'work': self, 'link_artists': link_artists, 'show_date': show_date})

        return t.render(c)
