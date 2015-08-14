from django.db import models

from fluent_contents.plugins.oembeditem.models import AbstractOEmbedItem


class OEmbedWithCaptionItem(AbstractOEmbedItem):
    caption = models.TextField()

    help_me_out_here = 'Online Media such as a Vimeo embed with a caption ' \
                       'displayed with it. The video will still scale within ' \
                       '''the responsive design, but won't stretch beyond ''' \
                       'max width.'

    class Meta:
        verbose_name = 'Online Media with Caption'

