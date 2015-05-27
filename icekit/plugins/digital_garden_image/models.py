from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem
from icekit.utils import implementation


# Ensure django-content-browser dependency is installed.
try:
    from content_browser.models import DigitalGardenImage
except ImportError:
    raise NotImplementedError(
        'Please install `django-content-browser` to use the'
        '`icekit.plugins.digital_garden_image` plugin.')

# Ensure required settings for django-content-browser have been defined.
implementation.check_settings(['NETX'])


@python_2_unicode_compatible
class DigitalGardenImageItem(ContentItem):
    """
    Content item for Digital Garden Image from NetX.
    """
    image = models.ForeignKey(DigitalGardenImage)

    class Meta:
        verbose_name = _('Digital Garden Image')
        verbose_name_plural = _('Digital Garden Images')

    def __str__(self):
        return str(self.image)
