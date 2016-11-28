# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0010_eventbase_is_drop_in'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventbase',
            name='derived_from',
            field=models.ForeignKey(related_name='derivitives', editable=False, blank=True, to='icekit_events.EventBase', on_delete=django.db.models.deletion.SET_NULL, null=True),
        ),
        migrations.AlterField(
            model_name='eventbase',
            name='part_of',
            field=models.ForeignKey(related_name='contained_events', help_text=b'If this event is part of another event, select it here.', blank=True, to='icekit_events.EventBase', on_delete=django.db.models.deletion.SET_NULL, null=True),
        ),
        migrations.AlterField(
            model_name='eventbase',
            name='primary_type',
            field=models.ForeignKey(related_name='events', help_text=b'The primary type of this event: Talk, workshop, etc. Only public Event Types can be primary.', blank=True, to='icekit_events.EventType', on_delete=django.db.models.deletion.SET_NULL, null=True),
        ),
        migrations.AlterField(
            model_name='occurrence',
            name='generator',
            field=models.ForeignKey(to='icekit_events.EventRepeatsGenerator', blank=True, on_delete=django.db.models.deletion.SET_NULL, null=True),
        ),
    ]
