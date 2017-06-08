# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_moving_image', '0003_movingimagework_trailer'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='movingimagework',
            name='genre',
        ),
        migrations.AddField(
            model_name='movingimagework',
            name='genres',
            field=models.ManyToManyField(to='gk_collections_moving_image.Genre', null=True, blank=True),
        ),
    ]
