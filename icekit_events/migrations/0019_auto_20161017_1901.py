# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0018_auto_20161017_1312'),
    ]

    operations = [
        migrations.RenameField(
            model_name='eventbase',
            old_name='attendance_url',
            new_name='cta_url',
        ),
        migrations.RemoveField(
            model_name='eventbase',
            name='human_times',
        ),
        migrations.AddField(
            model_name='eventbase',
            name='cta_text',
            field=models.CharField(blank=True, verbose_name='Call to action', max_length=255, default='Book now'),
        ),
        migrations.AlterField(
            model_name='eventbase',
            name='human_dates',
            field=models.TextField(blank=True, help_text='Describe event dates in everyday language, e.g. "Every Sunday in March".'),
        ),
        migrations.AlterField(
            model_name='eventbase',
            name='special_instructions',
            field=models.TextField(blank=True, help_text='Describe special instructions for attending event, e.g. "Enter via the Jones St entrance".'),
        ),
    ]
