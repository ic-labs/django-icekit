# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0006_auto_20151015_0542'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='event',
            options={'ordering': ('date_starts', '-all_day', 'starts')},
        ),
        migrations.AlterField(
            model_name='event',
            name='date_ends',
            field=models.DateField(null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='event',
            name='date_starts',
            field=models.DateField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
