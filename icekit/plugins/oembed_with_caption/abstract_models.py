from django.db import models

from fluent_contents.plugins.oembeditem.models import AbstractOEmbedItem


class AbstractOEmbedWithCaptionItem(AbstractOEmbedItem):
    caption = models.TextField(
        blank=True,
    )

    is_16by9 = models.BooleanField(
        default=True,
        help_text="Render this item in a 16x9 box (as opposed to 4x3)"
    )

    help_me_out_here = 'Online Media such as a Vimeo embed with a caption ' \
                       'displayed with it. The video will still scale within ' \
                       '''the responsive design, but won't stretch beyond ''' \
                       'max width.'

    class Meta:
        verbose_name = 'Online Media with Caption'
        abstract = True

