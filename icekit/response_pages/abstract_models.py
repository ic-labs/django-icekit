from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import PlaceholderField

from . import appsettings


RESPONSE_HTTP404 = '404'
RESPONSE_HTTP500 = '500'

RESPONSES = (
    (RESPONSE_HTTP404, _('Page Not Found')),
    (RESPONSE_HTTP500, _('Internal Server Error')),
)


@python_2_unicode_compatible
class AbstractResponsePage(models.Model):
    """
    Response Pages are designed to be custom pages that allow the user
    to manage the content for pages such and 404 and 500.
    """
    title = models.CharField(
        max_length=255,
    )
    type = models.CharField(
        choices=RESPONSES,
        max_length=5,
        unique=True,
    )
    is_active = models.BooleanField(
        default=False,
    )
    content = PlaceholderField(
        'response_page',
        plugins=appsettings.RESPONSE_PAGE_CONTENT_PLUGINS,
    )

    class Meta:
        abstract = True

    def __str__(self):
        return self.get_type_display()
