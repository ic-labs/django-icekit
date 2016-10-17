# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import icekit_events.models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0017_rename_event_to_eventbase'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='eventbase',
            options={'ordering': ('title', 'pk'), 'verbose_name': 'Event'},
        ),
        migrations.AddField(
            model_name='eventbase',
            name='slug',
            field=models.SlugField(default='', max_length=255),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='eventrepeatsgenerator',
            name='end',
            field=models.DateTimeField(default=icekit_events.models.default_ends, verbose_name=b'first end', db_index=True),
        ),
        migrations.AlterField(
            model_name='eventrepeatsgenerator',
            name='start',
            field=models.DateTimeField(default=icekit_events.models.default_starts, verbose_name=b'first start', db_index=True),
        ),
    ]
