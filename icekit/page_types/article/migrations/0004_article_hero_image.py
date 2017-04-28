# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0009_auto_20161026_2044'),
        ('icekit_article', '0003_auto_20161110_1125'),
    ]

    operations = [
        migrations.AddField(
            model_name='article',
            name='hero_image',
            field=models.ForeignKey(related_name='+', null=True, help_text=b'The hero image for this content.', blank=True, to='icekit_plugins_image.Image'),
        ),
    ]
