# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0003_auto_20161021_1658'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventbase',
            name='part_of',
            field=models.ForeignKey(to='icekit_events.EventBase', null=True, blank=True, related_name='contained_events'),
        ),
    ]
