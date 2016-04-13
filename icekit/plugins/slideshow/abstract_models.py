from django.db import models
from django.utils import six
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem, PlaceholderField

from icekit.publishing.models import PublishingModel

from . import appsettings


@python_2_unicode_compatible
class AbstractUnpublishableSlideShow(models.Model):
    """
    A reusable Slide Show.
    """
    title = models.CharField(
        max_length=255,
    )
    show_title = models.BooleanField(
        default=False,
        help_text=_('Should the title of the slide show be displayed?')
    )
    content = PlaceholderField(
        'slide_show_content',
        plugins=appsettings.SLIDE_SHOW_CONTENT_PLUGINS,
    )

    class Meta:
        abstract = True

    def __str__(self):
        return self.title


@python_2_unicode_compatible
class AbstractSlideShow(AbstractUnpublishableSlideShow, PublishingModel):

    class Meta:
        abstract = True

    def __str__(self):
        return self.title


@python_2_unicode_compatible
class AbstractSlideShowItem(ContentItem):
    """
    An slide show from the SlideShow model.
    """
    slide_show = models.ForeignKey(
        'SlideShow',
        help_text=_('A slide show from the slide show library.')
    )

    class Meta:
        abstract = True
        verbose_name = _('Slide show')
        verbose_name_plural = _('Slide shows')

    def __str__(self):
        return six.text_type(self.slide_show)
