# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0009_auto_20161117_1757'),
    ]

    operations = [
        migrations.AlterField(
            model_name='creatorbase',
            name='portrait',
            field=models.ForeignKey(to='icekit_plugins_image.Image', blank=True, on_delete=django.db.models.deletion.SET_NULL, null=True),
        ),
        migrations.AlterField(
            model_name='workcreator',
            name='role',
            field=models.ForeignKey(to='gk_collections_work_creator.Role', blank=True, on_delete=django.db.models.deletion.SET_NULL, null=True),
        ),
        migrations.AlterField(
            model_name='workimage',
            name='type',
            field=models.ForeignKey(to='gk_collections_work_creator.WorkImageType', blank=True, on_delete=django.db.models.deletion.SET_NULL, null=True),
        ),
    ]
