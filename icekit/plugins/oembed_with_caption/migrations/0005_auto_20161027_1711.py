# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_oembed_with_caption', '0004_auto_20160919_2008'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='oembedwithcaptionitem',
            table='contentitem_icekit_plugins_oembed_with_caption_oembedwithcaptionitem',
        ),
    ]
