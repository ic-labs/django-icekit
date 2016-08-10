# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0010_auto_20160203_1856'),
    ]

    operations = [
        migrations.AddField(
            model_name='event',
            name='show_in_calendar',
            field=models.BooleanField(default=True, help_text='Show this event in the public calendar'),
            preserve_default=True,
        ),
    ]
