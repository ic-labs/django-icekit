# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0013_merge'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventbase',
            name='human_times',
            field=models.CharField(blank=True, help_text='Describe event times in everyday language, e.g. "10am&ndash;5pm, 8pm on Thursdays".', max_length=255),
        ),
    ]
