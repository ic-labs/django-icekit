# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0017_eventpage'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='event',
            options={'verbose_name': 'Event'},
        ),
        migrations.AlterModelOptions(
            name='eventpage',
            options={'verbose_name': 'Event Page'},
        ),
    ]
