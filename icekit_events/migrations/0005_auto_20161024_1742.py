# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0004_eventbase_part_of'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventbase',
            name='price_line',
            field=models.CharField(max_length=255, help_text=b'A one-line description of the price for this event, e.g. "$12 / $10 / $6"', blank=True),
        ),
        migrations.AlterField(
            model_name='eventbase',
            name='part_of',
            field=models.ForeignKey(help_text=b'If this event is part of another event, select it here.', blank=True, related_name='contained_events', null=True, to='icekit_events.EventBase'),
        ),
    ]
