import re
import json
import urllib

from django.core.exceptions import ValidationError
from django.core.urlresolvers import reverse
from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _

from fluent_contents.models import ContentItem

from icekit.content_collections.abstract_models import TitleSlugMixin
from icekit.models import ICEkitFluentContentsMixin
from icekit.mixins import ListableMixin, HeroMixin

from . import appsettings


@python_2_unicode_compatible
class Location(
    ICEkitFluentContentsMixin,
    TitleSlugMixin,
    ListableMixin,
    HeroMixin,
):
    """
    Location model with fluent contents.
    """
    GOOGLE_MAPS_HREF_ROOT = '//maps.google.com/maps?'
    LAT_LONG_REGEX = re.compile(r'^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$')
    DEFAULT_MAP_ZOOM = 15

    map_description = models.TextField(
        help_text=_('A textual description of the location.'),
    )
    map_center = models.CharField(
        max_length=255,
        blank=True,
        help_text='''
            Location's description, address or latitude/longitude combination.
            <br />
            <br />
            Examples:
            <br><br><em>San Francisco Museum of Modern Art</em>
            <br><br><em>or</em>
            <br><br><em>151 3rd St, San Francisco, CA 94103</em>
            <br><br><em>or</em>
            <br><br><em>37.785710, -122.401045</em>
        '''
    )
    map_zoom = models.PositiveIntegerField(
        default=DEFAULT_MAP_ZOOM,
        help_text='''
            A positive number that indicates the zoom level of the map and
            defaults to {}.
            <br>
            Maps on Google Maps have an integer 'zoom level' which defines the
            resolution of the current view. Zoom levels between 0 (the lowest
            zoom level, in which the entire world can be seen on one map) and
            21+ (down to streets and individual buildings) are possible within
            the default roadmap view.
        '''.format(DEFAULT_MAP_ZOOM)
    )
    map_marker = models.CharField(
        max_length=255,
        blank=True,
        help_text='''
            An override for the map's marker, which defaults to the center of
            the map.
            <br>
            The value should take a similar form to the map center: a
            description, address, or latitude/longitude combination
        '''
    )
    map_embed_code = models.TextField(
        blank=True,
        help_text='''
            The HTML code that embeds a map.
            <br>
            This is an optional override for the map automatically generated
            from the map center, map zoom, and map marker fields
        '''
    )

    is_home_location = models.BooleanField(
        default=False,
        help_text='''
            Is this location at this institution? If not it is considered to be
            remote
        '''
    )

    address = models.TextField(
        blank=True,
        help_text='''
            Location's address to show to the public, which may differ from
            the information used as the map centre.
        '''
    )
    phone_number = models.CharField(
        max_length=255,
        blank=True,
        help_text='''
            Location's contact phone number to show to the public.
        '''
    )
    url = models.URLField(
        blank=True,
        help_text='''
            Location's external web site to show to the public.
        '''
    )
    email = models.EmailField(
        blank=True,
        help_text='''
            Location's email address to show to the public.
        '''
    )
    email_call_to_action = models.CharField(
        max_length=255,
        default='Email',
        help_text='''
            Call to action text to show next to the location's email address.
        '''
    )

    class Meta:
        unique_together = (('slug', 'publishing_linked'), )

    def __str__(self):
        return self.title

    def clean(self):
        if not self.map_center and not self.map_embed_code:
            raise ValidationError(
                'Either the map center or the map embed code must be defined'
            )

    def get_absolute_url(self):
        return reverse(
            'icekit_plugins_location_detail',
            kwargs={'slug': self.slug}
        )

    def render_map(self):
        """
        Returns either the `map_embed_code` field or renders a container and
        JSON that is picked up by `icekit/plugins/location/location_map.js`
        which mounts a responsive static map with overlays and links
        """

        if self.map_embed_code.strip():
            return self.map_embed_code

        return (
            '<div id="{container_id}" class="location-map"></div>'
            '<script>'
            '    gkLocationMaps = window.gkLocationMaps || [];'
            '    gkLocationMaps.push({data});'
            '</script>'
        ).format(
            container_id=self.get_map_element_id(),
            data=json.dumps(self.get_map_data()),
        )

    def get_map_data(self):
        """
        Returns a serializable data set describing the location
        """

        return {
            'containerSelector': '#' + self.get_map_element_id(),
            'center': self.map_center,
            'marker': self.map_marker or self.map_center,
            'zoom': self.map_zoom,
            'href': self.get_map_href(),
            'key': appsettings.GOOGLE_MAPS_API_KEY,
            # Python's line-splitting is more cross-OS compatible, so we feed
            # a pre-built array to the front-end
            'description': [
                line for line in self.map_description.splitlines() if line
            ],
        }

    def get_map_href(self):
        """
        Returns a link to an external view of the map
        """

        map_href_center = self.map_marker or self.map_center

        if self.LAT_LONG_REGEX.match(map_href_center):
            params = {'ll': map_href_center}
        else:
            params = {'q': map_href_center}

        return self.GOOGLE_MAPS_HREF_ROOT + urllib.urlencode(params)

    def get_map_element_id(self):
        """
        Returns a unique identifier for a map element
        """
        return 'location-map-' + str(id(self))


@python_2_unicode_compatible
class LocationItem(ContentItem):
    location = models.ForeignKey(
        Location,
        on_delete=models.CASCADE,
    )

    class Meta:
        verbose_name = _('Location')
        verbose_name_plural = _('Locations')

    def __str__(self):
        return str(self.location)
