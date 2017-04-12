from django.db import models
from django.utils.safestring import mark_safe
from django_countries.fields import CountryField
from icekit.content_collections.abstract_models import TitleSlugMixin

from glamkit_collections.utils.countries import ISO_CONTINENTS


class Country(TitleSlugMixin):
    """
    A model that represents a country on earth.
    
    This is initially derived from the countries in django-countries, but the
    user can modify the list to suit their needs (including preferred designations
    and historical countries)
    """
    iso_country = CountryField(blank=True)
    continent = models.CharField(
        choices=ISO_CONTINENTS,
        blank=True,
        null=True,
        max_length=31)

    class Meta:
        verbose_name_plural = "Countries"
        ordering = ('slug',)

    def flag(self):
        if self.iso_country:
            return self.iso_country.unicode_flag
        return ""

    def title_with_flag(self):
        if self.iso_country:
            return mark_safe(u"{0}&nbsp;{1}".format(self.iso_country.unicode_flag, self.title))
        else:
            return mark_safe(u"&emsp;&nbsp;{0}".format(self.title))
    title_with_flag.verbose_name = "Country"



class GeographicLocation(models.Model):
    """
    A model that represents a location on earth.

    TODO: Currently this just represents textual fields, but will be extended to 
    include Mapzen IDs, which get us Maps, polygons, etc.
    """
    colloquial_historical = models.CharField(
        "Colloquial or historical name",
        blank=True,
        max_length=255,
        help_text='The colloquial or historical name of the place, e.g., "East Bay"'
    )
    neighborhood = models.CharField(
        blank=True,
        max_length=255
    )
    city = models.CharField(
        blank=True,
        max_length=255
    )
    state_province = models.CharField(
        "State or province",
        blank=True,
        max_length=255
    )
    country = models.ForeignKey(Country, null=True, blank=True)

    class Meta:
        ordering = ('colloquial_historical', 'country', 'state_province', 'city', 'neighborhood',)

    def __unicode__(self):
        """
        :return: 
        """
        levels = (x for x in (self.neighborhood, self.city, self.state_province, unicode(self.country)) if x)
        r = ", ".join (levels)
        if self.colloquial_historical:
            if r:
                return "{0} ({1})".format(self.colloquial_historical, r)
            else:
                return self.colloquial_historical
        return r


    def flag(self):
        if self.country:
            return self.country.flag()
        return ""
