# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0009_auto_20161125_1538'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventbase',
            name='is_drop_in',
            field=models.BooleanField(default=False, help_text=b'Check to indicate that the event/activity can be attended at any time within the given time range.'),
        ),
    ]
