# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_oembed_with_caption', '0003_oembedwithcaptionitem_is_16by9'),
    ]

    operations = [
        migrations.AlterField(
            model_name='oembedwithcaptionitem',
            name='is_16by9',
            field=models.BooleanField(default=True, help_text=b'Render this item in a 16x9 box (as opposed to 4x3)'),
        ),
    ]
