# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_oembed_with_caption', '0006_auto_20161027_2330'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='oembedwithcaptionitem',
            options={
                'verbose_name': 'Embedded media',
                'verbose_name_plural': 'Embedded media'
            },
        ),
    ]
