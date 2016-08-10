# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import datetime
from .. import models as icekit_events_models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0004_auto_20150607_2336'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='ends',
            field=models.DateTimeField(default=icekit_events_models.default_ends, null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='event',
            name='starts',
            field=models.DateTimeField(default=icekit_events_models.default_starts, null=True, blank=True),
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
