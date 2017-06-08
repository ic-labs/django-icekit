# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0002_recurrence_rules'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventbase',
            name='human_dates',
            field=models.CharField(blank=True, help_text='Describe event dates in everyday language, e.g. "Every Sunday in March".', max_length=255),
        ),
    ]
