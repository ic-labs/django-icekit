from django.db import models
from django.template import Context
from django.template import Template
from django.utils import six
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem, PlaceholderField

from icekit.models import ICEkitContentsMixin

from . import appsettings


@python_2_unicode_compatible
class AbstractSlideShow(ICEkitContentsMixin):
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
        verbose_name = "Image gallery"
        verbose_name_plural = "Image galleries"

    def __str__(self):
        return self.title

    def preview(self, request):
        t = Template(
            """{% load icekit_tags thumbnail %}
                {% for item in obj.content.get_content_items %}
                    <img src="{% thumbnail item.image.image 30x30 %}" alt="">
                {% empty %}
                    <cite>No items</cite>
                {% endfor %}
            """
        )
        c = Context({
            'obj': self,
        })
        return t.render(c)


@python_2_unicode_compatible
class AbstractSlideShowItem(ContentItem):
    """
    A content item that renders an image gallery from the SlideShow model.
    """
    slide_show = models.ForeignKey(
        'SlideShow',
        help_text=_('An image gallery.'),
        on_delete=models.CASCADE,
    )

    class Meta:
        abstract = True
        verbose_name = _('Slide show')
        verbose_name_plural = _('Slide shows')

    def __str__(self):
        return six.text_type(self.slide_show)
