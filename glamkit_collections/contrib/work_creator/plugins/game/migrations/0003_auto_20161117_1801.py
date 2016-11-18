# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_moving_image', '0005_auto_20161117_1801'),
        ('gk_collections_game', '0002_game_trailer'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='game',
            name='genre',
        ),
        migrations.AddField(
            model_name='game',
            name='duration_minutes',
            field=models.PositiveIntegerField(blank=True, verbose_name=b'Duration (minutes)', null=True, help_text=b'How long (in minutes) should a visitor spend with this content?'),
        ),
        migrations.AddField(
            model_name='game',
            name='genres',
            field=models.ManyToManyField(to='gk_collections_moving_image.Genre', blank=True),
        ),
    ]
