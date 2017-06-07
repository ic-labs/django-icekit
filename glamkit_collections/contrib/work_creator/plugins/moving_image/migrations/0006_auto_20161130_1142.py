# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_moving_image', '0005_auto_20161117_1801'),
    ]

    operations = [
        migrations.AddField(
            model_name='mediatype',
            name='title_plural',
            field=models.CharField(max_length=255, blank=True, help_text=b"Optional plural version of title (if appending 's' isn't correct)"),
        ),
        migrations.AlterField(
            model_name='movingimagework',
            name='media_type',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, blank=True, to='gk_collections_moving_image.MediaType'),
        ),
        migrations.AlterField(
            model_name='movingimagework',
            name='rating',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, blank=True, to='gk_collections_moving_image.Rating'),
        ),
    ]
