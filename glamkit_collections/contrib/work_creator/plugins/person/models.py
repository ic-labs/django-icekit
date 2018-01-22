from django.db import models
from django.utils.safestring import mark_safe
from django.utils.text import slugify

from icekit.utils.strings import is_empty

from glamkit_collections.contrib.work_creator.models import CreatorBase


class PersonCreator(CreatorBase):
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
        help_text='This field identifies the gender of the creator for rapid '
                  'retrieval and categorization, e.g., "male" or "female". Use lowercase.'
    )

    primary_occupation = models.CharField(
        blank=True,
        max_length=255,
    )

    birth_place = models.CharField(
        blank=True,
        max_length=255,
        help_text='The location of the creator\'s birth, e.g., "Utrecht"'
    )
    birth_place_historic = models.CharField(
        blank=True,
        max_length=255,
        help_text='The historical name of the place at the time of the '
                  'creator\'s birth, e.g., "Flanders"'
    )
    death_place = models.CharField(
        blank=True,
        max_length=255,
        help_text='The location of the creator\'s death, e.g., "Antwerp."',
    )

    #cultural background
    background_ethnicity = models.CharField(
        blank=True,
        max_length=255,
        help_text='The affiliation of the creator with a group not based on '
                  'geopolitical boundaries, a cultural affiliation, '
                  'e.g., "Inuit" or "Mayan."'  # In the absence of a known
                  # creator, the culture itself may be the creator/maker that is
                  #'displayed.
    )
    background_nationality = models.CharField(
        blank=True,
        max_length=255,
        help_text='This field contains information about the geopolitical '
                  'entity that claims the creator, expressed as a nationality, '
                  'e.g., "French," "American," "Flemish."'
    )
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

    class Meta:
        verbose_name = "artist"

    def derive_and_set_name_fields_and_slug(
        self, set_name_sort=True, set_slug=True
    ):
        """
        Override this method from `CreatorBase` to handle additional name
        fields for Person creators.

        This method is called during `save()`
        """
        super(PersonCreator, self).derive_and_set_name_fields_and_slug(
            set_name_sort=False, set_slug=False)
        # Collect person name fields, but only if they are not empty
        person_names = [
            name for name in [self.name_family, self.name_given]
            if not is_empty(name)
        ]
        # if empty, set `name_sort` = '{name_family}, {name_given}' if these
        # person name values are available otherwise `name_full`
        if set_name_sort and is_empty(self.name_sort):
            if person_names:
                self.name_sort = ', '.join(person_names)
            else:
                self.name_sort = self.name_full
        # if empty, set `slug` to slugified '{name_family} {name_given}' if
        # these person name values are available otherwise slugified
        # `name_full`
        if set_slug and is_empty(self.slug):
            if person_names:
                self.slug = slugify(' '.join(person_names))
            else:
                self.slug = slugify(self.name_full)

    def lifespan_for_web(self, join="&nbsp;&ndash; "):
        """
        Returns lifespan formatted for the web, for example:

        1850 - 1922
        1850, Cologne - 1922, Berlin
        1968 -
        n.d. - 1540s
        """
        birth = ", ".join(filter(None, (
            self.start_date_display,
            self.start_place
        )))
        death = ", ".join(filter(None, (
            self.end_date_display,
            self.end_place
        )))

        if death and not birth:
            if not death.startswith("died"):
                return mark_safe("n.d.&nbsp;&ndash;&nbsp;" + death)

        return mark_safe(join.join(filter(None, (birth, death))))

    def get_type(self):
        if self.primary_occupation:
            return self.primary_occupation
        roles = self.get_primary_roles()
        if roles:
            return roles[0].role
        return "person"

    def get_type_plural(self):
        if self.primary_occupation:
            return self.primary_occupation
        roles = self.get_primary_roles()
        if roles:
            return roles[0].role.get_plural()
        return "people"

    def derive_sort_name(self):
        names = (self.name_display or self.name_full).strip().split()
        if len(names) > 1:
            return u"%s, %s" % (names[-1], " ".join(names[:-1]))
        else:
            return super(PersonCreator, self).derive_sort_name()
