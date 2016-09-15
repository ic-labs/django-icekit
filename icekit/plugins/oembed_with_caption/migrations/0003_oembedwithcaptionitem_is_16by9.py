# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_oembed_with_caption', '0002_auto_20160821_2140'),
    ]

    operations = [
        migrations.AddField(
            model_name='oembedwithcaptionitem',
            name='is_16by9',
            field=models.BooleanField(default=True, help_text=b'Render this content in a 16x9 box (as opposed to 4x3)'),
        ),
    ]
