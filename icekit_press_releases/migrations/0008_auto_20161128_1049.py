# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_press_releases', '0007_auto_20161117_1201'),
    ]

    operations = [
        migrations.AlterField(
            model_name='pressreleaselisting',
            name='hero_image',
            field=models.ForeignKey(related_name='+', help_text=b'The hero image for this content.', blank=True, to='icekit_plugins_image.Image', on_delete=django.db.models.deletion.SET_NULL, null=True),
        ),
    ]
