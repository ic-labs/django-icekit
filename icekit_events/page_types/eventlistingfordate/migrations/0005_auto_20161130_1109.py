# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0009_auto_20161026_2044'),
        ('eventlistingfordate', '0004_auto_20161115_1118'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventlistingpage',
            name='hero_image',
            field=models.ForeignKey(help_text=b'The hero image for this content.', blank=True, null=True, to='icekit_plugins_image.Image', related_name='+', on_delete=django.db.models.deletion.SET_NULL),
        ),
    ]
