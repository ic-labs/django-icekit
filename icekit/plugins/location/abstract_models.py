from django.db import models
from django.utils.encoding import python_2_unicode_compatible

from icekit.content_collections.abstract_models import TitleSlugMixin
from icekit.mixins import ListableMixin, HeroMixin, GoogleMapMixin


@python_2_unicode_compatible
class AbstractLocation(
    TitleSlugMixin,
    ListableMixin,
    HeroMixin,
):
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
            Location's address to show to the public
        '''
    )
    phone_number = models.CharField(
        max_length=255,
        blank=True,
        help_text='''
            Location's contact phone number to show to the public.
        '''
    )
    phone_number_call_to_action = models.CharField(
        max_length=255,
        blank=True,
        default='Phone',
        help_text='''
            Call to action text to show for the location's phone number.
        '''
    )
    url = models.URLField(
        blank=True,
        help_text='''
            Location's external web site to show to the public.
        '''
    )
    url_call_to_action = models.CharField(
        max_length=255,
        blank=True,
        default='Website',
        help_text='''
            Call to action text to show for the location's url.
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
        blank=True,
        default='Email',
        help_text='''
            Call to action text to show for the location's email address.
        '''
    )

    class Meta:
        abstract = True

    def __str__(self):
        return self.title


class AbstractLocationWithGoogleMap(
    AbstractLocation,
    GoogleMapMixin,
):

    class Meta:
        abstract = True
