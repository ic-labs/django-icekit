# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_article', '0006_auto_20161117_1800'),
    ]

    operations = [
        migrations.AlterField(
            model_name='article',
            name='hero_image',
            field=models.ForeignKey(help_text=b'The hero image for this content.', blank=True, null=True, to='icekit_plugins_image.Image', related_name='+', on_delete=django.db.models.deletion.SET_NULL),
        ),
        migrations.AlterField(
            model_name='articlecategorypage',
            name='hero_image',
            field=models.ForeignKey(help_text=b'The hero image for this content.', blank=True, null=True, to='icekit_plugins_image.Image', related_name='+', on_delete=django.db.models.deletion.SET_NULL),
        ),
    ]
