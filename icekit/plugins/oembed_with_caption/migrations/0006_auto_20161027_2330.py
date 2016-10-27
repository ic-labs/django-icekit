# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_oembed_with_caption', '0005_auto_20161027_1711'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='oembedwithcaptionitem',
            options={},
        ),
        migrations.AlterModelTable(
            name='oembedwithcaptionitem',
            table='contentitem_oembed_with_caption_item',
        ),
    ]
