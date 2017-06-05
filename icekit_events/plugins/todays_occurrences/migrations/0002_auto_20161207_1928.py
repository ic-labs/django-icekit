# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ik_events_todays_occurrences', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='todaysoccurrences',
            name='fall_back_to_next_day',
            field=models.BooleanField(default=True, help_text=b"if there are no events to show on a day, show the next day's instead."),
        ),
        migrations.AddField(
            model_name='todaysoccurrences',
            name='title',
            field=models.CharField(max_length=255, help_text=b'Title to show. Natural date is appended.', blank=True),
        ),
    ]
