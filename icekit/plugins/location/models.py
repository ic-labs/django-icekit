from django.core.urlresolvers import reverse
from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _

from fluent_contents.models import ContentItem

from icekit.models import ICEkitFluentContentsMixin
from icekit.managers import GoogleMapManager
from icekit.publishing.managers import PublishingManager

from icekit.plugins.location import abstract_models


# We must combine managers here otherwise the `PublishingManager` applied via
# `ICEkitFluentContentsMixin` will clobber the existing `GoogleMapManager`
class PublishingManagerAndGoogleMapManager(
    PublishingManager,
    GoogleMapManager,
):
    pass


class Location(
    ICEkitFluentContentsMixin,
    abstract_models.AbstractLocationWithGoogleMap,
):
    """
    Location model with fluent contents.
    """
    objects = PublishingManagerAndGoogleMapManager()

    class Meta:
        unique_together = (('slug', 'publishing_linked'), )
        ordering = ('title',)

    def get_absolute_url(self):
        return reverse(
            'icekit_plugins_location_detail',
            kwargs={'slug': self.slug}
        )


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
        return unicode(self.location)
