# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_moving_image', '0004_auto_20161110_1419'),
    ]

    operations = [
        migrations.AddField(
            model_name='movingimagework',
            name='duration_minutes',
            field=models.PositiveIntegerField(blank=True, verbose_name=b'Duration (minutes)', null=True, help_text=b'How long (in minutes) should a visitor spend with this content?'),
        ),
        migrations.AlterField(
            model_name='movingimagework',
            name='genres',
            field=models.ManyToManyField(to='gk_collections_moving_image.Genre', blank=True),
        ),
    ]
