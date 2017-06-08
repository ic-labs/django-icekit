# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0018_auto_20170307_1458'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='eventtype',
            options={'verbose_name_plural': 'Event categories', 'verbose_name': 'Event category'},
        ),
        migrations.AlterField(
            model_name='eventbase',
            name='primary_type',
            field=models.ForeignKey(blank=True, null=True, to='icekit_events.EventType', on_delete=django.db.models.deletion.SET_NULL, related_name='events', verbose_name=b'Primary category', help_text=b'The primary type of this event: Talk, workshop, etc. Only public Event Types can be primary.'),
        ),
        migrations.AlterField(
            model_name='eventbase',
            name='secondary_types',
            field=models.ManyToManyField(to='icekit_events.EventType', related_name='secondary_events', blank=True, help_text=b'Additional/internal types: Education or members events, for example.', verbose_name=b'Secondary categories'),
        ),
    ]
