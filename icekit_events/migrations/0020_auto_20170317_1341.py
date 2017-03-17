# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0019_auto_20170310_1220'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventbase',
            name='secondary_types',
            field=models.ManyToManyField(verbose_name=b'Secondary categories', help_text=b"Additional or internal types: Education or members events, for example. Events show in listings for <em>every</em> type they're associated with.", to='icekit_events.EventType', blank=True, related_name='secondary_events'),
        ),
    ]
