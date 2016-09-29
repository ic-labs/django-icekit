# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0014_auto_20160810_1036'),
    ]

    operations = [
        migrations.AddField(
            model_name='event',
            name='attendance_url',
            field=icekit.fields.ICEkitURLField(help_text='The URL where visitors can arrange to attend an event by purchasing tickets or RSVPing.', max_length=300, null=True, blank=True),
        ),
        migrations.AddField(
            model_name='event',
            name='human_dates',
            field=models.TextField(help_text='Describe event dates in humane language.', blank=True),
        ),
        migrations.AddField(
            model_name='event',
            name='human_times',
            field=models.TextField(help_text='Describe event times in humane language.', blank=True),
        ),
        migrations.AddField(
            model_name='event',
            name='special_instructions',
            field=models.TextField(help_text='Describe special instructions for attending event.', blank=True),
        ),
    ]
