# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0009_auto_20161026_2044'),
        ('gk_collections_work_creator', '0004_auto_20161026_1828'),
    ]

    operations = [
        migrations.AddField(
            model_name='workbase',
            name='images',
            field=models.ManyToManyField(through='gk_collections_work_creator.WorkImage', to='icekit_plugins_image.Image'),
        ),
    ]
