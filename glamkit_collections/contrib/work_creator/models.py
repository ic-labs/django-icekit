class CreatorBase(FluentFieldsMixin, BoostedTermsMixin, PublishingModel, PolymorphicModel):
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
        unique=True,
        db_index=True,
    )  # Alt slug redirects to it.
    alt_slug = models.SlugField(
        max_length=255,
        unique=True,
        db_index=True
    )   # use unidecode + slugify for alt slug.
    # Alt slug matches should redirect to the canonical view.
    portrait = models.ForeignKey(
        Image,
        blank=True,
        null=True,
    )
    website = models.CharField(
        blank=True,
        max_length=255,
    )

    name_sort = models.CharField(
        max_length=255,
        help_text='For searching and organizing, the name or sequence of names '
                  'which determines the position of the creator in the list of '
                  'creators, so that he or she may be found where expected, '
                  'e.g. "Rembrandt" under "R" or "Guercino" under "G"'
    )

    class Meta:
        abstract = True
        ordering = ('name_sort', )

    def __unicode__(self):
        return self.name_display

    def get_public_works(self):
        return self.works.all().published()

    def get_work_count(self):
        return self.works.count()

    def get_public_work_count(self):
        return self.public_works.count()


class WorkBase(FluentFieldsMixin, BoostedTermsMixin, PublishingModel, PolymorphicModel):
    # meta
    slug = models.CharField(max_length=255, unique=True, db_index=True)
    # using accession number (URL-encoded) for canonical slug
    alt_slug = models.SlugField(max_length=255, unique=True, db_index=True)
    # using slugified, no-hyphens. Alt slug matches should redirect to the
    # canonical view.

    # what's it called
    title_display = models.CharField(
        max_length=255,
        help_text='The official title of this object. Includes series title '
                  'when appropriate.'
    )  # used on 'Explore Modern Art'

    # who made it
    creators = models.ManyToManyField(
        'CreatorBase', through='WorkCreator', related_name='works'
    )

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
        help_text=_("An optional override to use when the work is displayed at thumbnail dimensions"),
        related_name='%(app_label)s_%(class)s_related',
    )

    # how we got it
    accession_number = models.CharField(
        max_length=255,
        help_text="The five components of the Accession number concatenated "
                  "in a single string for efficiency of display and retrieval."
    )  # used on 'Explore Modern Art'  # 77143 - that's all of them


    external_url = models.URLField(
        help_text="A URL at which to view this work, if available online",
        blank=True,
    )


    class Meta:
        abstract = True
        ordering= ("date_sort_latest", )

    def __unicode__(self):
        # tempted to use self.title_text, but risk recursion error
        return u"%s (%s)" % (self.title_full or self.title_display, self.date_display)


    def public_images(self):
        # using Optimizing manager will prefetch a list.
        if hasattr(self, 'prefetched_public_images'):
            return self.prefetched_public_images

        queryset = self.images.filter(self.PUBLIC_IMAGE_QS).order_by_view()
        return queryset

    def get_hero_image(self):
        if not hasattr(self, "_hero_image"):
            try:
                self._hero_image = self.public_images()[0]
            except IndexError:
                self._hero_image = None
        return self._hero_image

    def get_thumbnail_image(self):
        """
        Returns the most appropriate ImageField for use as an artwork's thumbnail
        """
        if self.thumbnail_override:
            return self.thumbnail_override.image
        if self.hero_image:
            return self.hero_image.downloaded_image

    def creator_name_pairs(self):
        return [(a.name_display, a.name_sort) for a in self.primary_creators()]

    ### different sublists of creators
    def creators_with_role(self, role):
        if hasattr(self, 'prefetched_artworkcreators'):
            paa = self.prefetched_artworkcreators
            return [a.creator for a in paa if (a.role.lower() == role and a.creator.is_ok_for_web)]
        else:
            return [a.creator for a in self.artworkcreator_set.filter(role__iexact=role, creator__is_ok_for_web=True)]


    def primary_creators(self):
        # returns the creators with role = Primary - hopefully just one.
        # these are the creators to be used in the credit line
        # in etl, we ensured that every work had at least one.
        # implied order by 'Artworkcreator.order'
        return self.creators_with_role("primary")

    def nonprimary_creators(self):
        # returns the creators with role = ""
        return self.creators_with_role("")

    def primary_and_nonprimary_creators(self):
        # returns the creators with role in "Primary" or "", with Primary coming first.
        return self.primary_creators() + self.nonprimary_creators()

    def non_creator_roles(self):
        # returns the Artworkcreators with role not in (Primary, creator).
        # this would be e.g. foundry page and ideally wouldn't have a URL.
        if hasattr(self, 'prefetched_artworkcreators'):
            return filter(
                lambda a: (a.role != '') and (a.role.lower() != "primary") and a.creator.is_ok_for_web,
                self.prefetched_artworkcreators
            )
        else:
            return self.artworkcreator_set.filter(creator__is_ok_for_web=True).exclude(role="").exclude(role__iexact="primary") #implied order by 'Artworkcreator.order'


    ### cleaned-up creator lists, titles and captions, for web and in plain text.

    def creators_text(self):
        return grammatical_join([a.name_display for a in self.primary_creators()])

    def creators_html(self):
        return mark_safe(grammatical_join([a.name_display_html() for a in self.primary_creators()]))

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
            {{ work.creators_text }}, {{ work.title_text }}{% if work.date_display %}, {{ work.date_display }}{% endif %}
        {% endspaceless %}""")
        c = Context({'work': self})

        return t.render(c)


    def short_caption_html(self, link_creators=True, show_date=True):
        t = Template("""
        	{% if link_creators %}{{ work.creators_html }}{% else %}{{ work.creators_text }}{% endif %},
			{{ work.title_html }}{% if work.date_display and show_date %}, {{ work.date_display }}{% endif %}
        """)
        c = Context({'work': self, 'link_creators': link_creators, 'show_date': show_date})

        return t.render(c)


class WorkCreatorBase(models.Model):
    creator = models.ForeignKey(CreatorBase)
    work = models.ForeignKey(WorkBase)

    order = models.PositiveIntegerField()
    role = models.CharField(max_length=255)
    is_primary = models.BooleanField(default=True)

    class Meta:
        abstract = True
        unique_together = ('artist', 'artwork', 'role')
        ordering = ("order", )

    def __unicode__(self):
        return unicode(self.artwork)