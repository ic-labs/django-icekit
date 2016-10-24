from django.template import Template, Context
from django.utils.safestring import mark_safe
from django.core.urlresolvers import reverse
from django.db import models
from icekit.abstract_models import FluentFieldsMixin, BoostedTermsMixin


class CreatorBase(FluentFieldsMixin, BoostedTermsMixin):

    is_ok_for_web = models.BooleanField(default=False)

    name_display = models.CharField(
        max_length=255,
        help_text='The commonly known or generally recognized name of the '
                  'artist, for display, publication and reproduction purposes, '
                  'e.g., "Rembrandt" or "Guercino" as opposed to the full name '
                  '"Rembrandt Harmenszoon Van Rijn" or "Giovanni Francesco '
                  'Barbieri."'
    )

    #for URLs
    slug = models.CharField(
        max_length=255,
        unique=True,
        db_index=True,
        help_text="A unique Wikipedia-style (Asciified, _-separated) slug. "
                  "Duplicates have -1, -2, etc. appended"
    )  # Alt slug redirects to it.
    alt_slug = models.SlugField(
        max_length=255,
        unique=True,
        db_index=True
    )   # use unidecode + slugify for alt slug.
    # Alt slug matches should redirect to the canonical view.

    portrait = models.ForeignKey(
        'image.Image',
        blank=True,
        null=True,
    )

    #more name fields
    name_full = models.CharField(
        max_length=255,
        help_text='A public "label" composed of the Prefix, First Names, Last '
                  'Name Prefix, Last Name, Suffix, and Variant Name fields'
    )
    name_sort = models.CharField(
        max_length=255,
        help_text='For searching and organizing, the name or sequence of names '
                  'which determines the position of the artist in the list of '
                  'artists, so that he or she may be found where expected, '
                  'e.g. "Rembrandt" under "R" or "Guercino" under "G"'
    )  # used on 'Explore Modern Art'
    name_given = models.CharField(
        blank=True,
        max_length=255,
        help_text='All the names that precede the last name and last name '
                  'prefix, e.g., "Jan Davidszoon" (de Heem) or "George Wesley" '
                  '(Bellows)'
    )
    name_family = models.CharField(
        blank=True,
        max_length=255,
        help_text='The name you would look up in a standard reference work, '
                  'e.g., "Rijn," Rembrandt Harmenszoon van or '
                  '"Sanzio," Raphael'
    )


    # what is their gender
    gender = models.CharField(
        blank=True,
        max_length=255,
        help_text='This field identifies the gender of the artist for rapid '
                  'retrieval and categorization, e.g., "male" or "female"'
    )  # used on 'Explore Modern Art'

    website = models.CharField(
        blank=True,
        max_length=255,)

    life_info_is_living = models.BooleanField(
        blank=True,
        default=False,
        help_text='A flag to quickly indicate if the artist/maker is '
                  'currently living'
    )
    life_info_birth_date_display = models.CharField(
        blank=True,
        max_length=255,
        help_text='The display version of the artist\'s birth date, '
                  'e.g. "circa August 1645"',
        null=True
    )  # used on 'Explore Modern Art'
    life_info_birth_date_edtf = models.CharField(
        blank=True,
        max_length=63,
        help_text=
            '<a href="http://www.loc.gov/standards/datetime/'
            'implementations.html">EDTF</a>'
            " version of the artist\'s birth date, as best as we could parse"
            " from the display date e.g. \"1645-08~\""
    )
    life_info_birth_date_edtf_earliest = models.DateField(
        blank=True,
        null=True,
        help_text="If we found an EDTF-formatted date, this is the earliest "
                  "date that might reasonably be covered by the EDTF date. If "
                  "we don't have a date, value is null. e.g. '1645-07-16'",
    )
    life_info_birth_date_edtf_latest = models.DateField(
        blank=True,
        null=True,
        help_text="If we found an EDTF-formatted date, this is the latest "
                  "date that might reasonably be covered by the EDTF date. If "
                  "we don't have a date, value is null. e.g. '1645-09-17'",
    )
    life_info_birth_date_sort_earliest = models.DateField(
        blank=True,
        null=True,
        help_text="Single ISO date to use for sorting. Think of this as the "
                  "'most obvious' date represented by EDTF, with unknown parts "
                  "assigned LOWEST values by default. Sorting by this value "
                  "will make imprecise dates appear BEFORE precise dates. If "
                  "we don't have a date, the minimum date is used. "
                  "e.g. '1645-08-01'",
    )
    life_info_birth_date_sort_latest = models.DateField(
        blank=True,
        null=True,
        help_text="Single ISO date to use for sorting. Think of this as the "
                  "'most obvious' date represented by EDTF, with unknown parts "
                  "assigned HIGHEST values by default. Sorting by this value "
                  "will make imprecise dates appear AFTER precise dates. If we "
                  "don't have a date, the maximum date is used. "
                  "e.g. '1645-08-31'",
    )
    life_info_birth_place = models.CharField(
        blank=True,
        max_length=255,
        help_text='The location of the artist\'s birth, e.g., "Utrecht"'
    )  # used on 'Explore Modern Art'
    life_info_birth_place_historic = models.CharField(
        blank=True,
        max_length=255,
        help_text='The historical name of the place at the time of the '
                  'artist\'s birth, e.g., "Flanders"'
    )
    life_info_death_date_display = models.CharField(
        blank=True,
        max_length=255,
        help_text='The display version of the artist\'s death date, '
                  'e.g., "before 1720s"',
        null=True,
    )  # used on 'Explore Modern Art'
    life_info_death_date_edtf = models.CharField(
        blank=True,
        max_length=63,
        help_text=
            '<a href="http://www.loc.gov/standards/datetime/'
            'implementations.html">EDTF</a> '
            'version of the artist\'s death date, e.g. \"[..172x]\"'
    )
    life_info_death_date_edtf_earliest = models.DateField(
        blank=True,
        null=True,
        help_text="If we found an EDTF-formatted date, this is the earliest "
                  "date that might reasonably be covered by the EDTF date. If "
                  "we don't have a date, value is null. e.g. '1645-07-16'",
    )
    life_info_death_date_edtf_latest = models.DateField(
        blank=True,
        null=True,
        help_text="If we found an EDTF-formatted date, this is the latest "
            "date that might reasonably be covered by the EDTF date. If "
            "we don't have a date, value is null. e.g. '1645-09-17'",
    )
    life_info_death_date_sort_earliest = models.DateField(
        blank=True,
        null=True,
        help_text="Single ISO date to use for sorting. Think of this as the "
                  "'most obvious' date represented by EDTF, with unknown parts "
                  "assigned LOWEST values by default. Sorting by this value "
                  "will make imprecise dates appear BEFORE precise dates. If "
                  "we don't have a date, the minimum date is used. "
                  "e.g. '1645-08-01'",
    )
    life_info_death_date_sort_latest = models.DateField(
        blank=True,
        null=True,
        help_text="Single ISO date to use for sorting. Think of this as the "
                  "'most obvious' date represented by EDTF, with unknown parts "
                  "assigned HIGHEST values by default. Sorting by this value "
                  "will make imprecise dates appear AFTER precise dates. If we "
                  "don't have a date, the maximum date is used. "
                  "e.g. '1645-08-31'",
    )
    life_info_death_place = models.CharField(
        blank=True,
        max_length=255,
        help_text='The location of the artist\'s death, e.g., "Antwerp."',
    )  # used on 'Explore Modern Art'

    #cultural background
    background_ethnicity = models.CharField(
        blank=True,
        max_length=255,
        help_text='The affiliation of the artist with a group not based on '
                  'geopolitical boundaries, a cultural affiliation, '
                  'e.g., "Inuit" or "Mayan."'  # In the absence of a known
                  # artist, the culture itself may be the artist/maker that is
                  #'displayed.
    )
    background_nationality = models.CharField(
        blank=True,
        max_length=255,
        help_text='This field contains information about the geopolitical '
                  'entity that claims the artist, expressed as a nationality, '
                  'e.g., "French," "American," "Flemish."'
    )  # used on 'Explore Modern Art'
    #nat(-ive? -ional? -ural?) culture
    background_neighborhood = models.CharField(
        blank=True,
        max_length=255,)
    background_city = models.CharField(
        blank=True,
        max_length=255,)
    background_state_province = models.CharField(
        blank=True,
        max_length=255,)
    background_country = models.CharField(
        blank=True,
        max_length=255,)
    background_continent = models.CharField(
        blank=True,
        max_length=255,)

    biography_html = models.TextField(
        blank=True,
        help_text='A narrative field that provides for a lengthy description '
                  'of the artist\'s life and commentary on his/her '
                  'contributions and achievements. HTML, with&lt;p&gt; as the '
                  'outermost tags'
    )

    last_updated = models.DateTimeField(
        auto_now=True,
        help_text="Every shadow import updates this timestamp. This is used to determine which obsolete records to delete at the end of import."
    )


    class Meta:
        abstract = True
        ordering = ('name_sort', )

    def __unicode__(self):
        return self.name_display

    def get_absolute_url(self):
        return reverse('artist', args=[self.slug])

    def name_display_html(self):
        t = Template("""<a href="{{ artist.get_absolute_url }}">{{ artist.name_display }}</a>""")
        c = Context({'artist': self})
        return t.render(c)

    @property
    def public_artworks(self):
        return self.artworks.filter(is_ok_for_web=True)

    @property
    def artwork_count(self):
        return self.artworks.count()

    @property
    def public_artwork_count(self):
        return self.public_artworks.count()

    def lifespan_for_web(self, join="&nbsp;&ndash; "):
        """
        Returns lifespan formatted for the web, for example:

        1850 - 1922
        1850, Cologne - 1922, Berlin
        1968 -
        n.d. - 1540s
        """
        birth = ", ".join(filter(None, (
            self.life_info_birth_date_display,
            self.life_info_birth_place
        )))
        death = ", ".join(filter(None, (
            self.life_info_death_date_display,
            self.life_info_death_place
        )))

        if death and not birth:
            if not death.startswith("died"):
                return mark_safe("n.d.&nbsp;&ndash;&nbsp;" + death) # about 10 records do this

        return mark_safe(join.join(filter(None, (birth, death))))
