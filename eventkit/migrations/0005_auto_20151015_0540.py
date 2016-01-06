# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import datetime
import eventkit.models


class Migration(migrations.Migration):

    dependencies = [
        ('eventkit', '0004_auto_20150607_2336'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='ends',
            field=models.DateTimeField(default=eventkit.models.default_ends, null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='event',
            name='starts',
            field=models.DateTimeField(default=eventkit.models.default_starts, null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='event',
            name='date_ends',
            field=models.DateField(null=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='event',
            name='date_starts',
            field=models.DateField(null=True),
            preserve_default=False,
        ),
    ]
