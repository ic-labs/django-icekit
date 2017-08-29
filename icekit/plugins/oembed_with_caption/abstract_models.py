from django.db import models

from fluent_contents.plugins.oembeditem.models import AbstractOEmbedItem


class AbstractOEmbedWithCaptionItem(AbstractOEmbedItem):
    content_title = models.CharField('title', max_length=1000, blank=True)
    caption = models.TextField(
        blank=True,
    )

    is_16by9 = models.BooleanField(
        default=True,
        help_text="Render this item in a 16x9 box (as opposed to 4x3)"
    )

    help_text = 'Online Media such as a Vimeo embed with a caption ' \
                       'displayed with it. The video will still scale within ' \
                       '''the responsive design, but won't stretch beyond ''' \
                       'max width.'

    class Meta:
        verbose_name = 'Embedded Media with Caption'
        abstract = True

