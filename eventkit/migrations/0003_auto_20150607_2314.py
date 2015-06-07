# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import polymorphic_tree.models


class Migration(migrations.Migration):

    dependencies = [
        ('eventkit', '0002_auto_20150605_1418'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='is_repeat',
            field=models.BooleanField(default=False, editable=False),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='event',
            name='parent',
            field=polymorphic_tree.models.PolymorphicTreeForeignKey(related_name='children', blank=True, editable=False, to='eventkit.Event', null=True),
            preserve_default=True,
        ),
    ]
