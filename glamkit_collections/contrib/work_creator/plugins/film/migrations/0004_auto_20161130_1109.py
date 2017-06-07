# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_film', '0003_auto_20161117_1801'),
    ]

    operations = [
        migrations.AlterField(
            model_name='film',
            name='media_type',
            field=models.ForeignKey(blank=True, to='gk_collections_moving_image.MediaType', null=True, on_delete=django.db.models.deletion.SET_NULL),
        ),
        migrations.AlterField(
            model_name='film',
            name='rating',
            field=models.ForeignKey(blank=True, to='gk_collections_moving_image.Rating', null=True, on_delete=django.db.models.deletion.SET_NULL),
        ),
    ]
