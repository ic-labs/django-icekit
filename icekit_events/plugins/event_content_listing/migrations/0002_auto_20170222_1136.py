# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0016_auto_20161208_0030'),
        ('ik_event_listing', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventcontentlistingitem',
            name='from_date',
            field=models.DateTimeField(help_text=b'Only show events with occurrences that end after this date and time.', null=True, blank=True),
        ),
        migrations.AddField(
            model_name='eventcontentlistingitem',
            name='from_days_ago',
            field=models.IntegerField(help_text=b'Only show events with occurrences after this number of days into the past. Set this to zero to show only events with future occurrences.', null=True, blank=True),
        ),
        migrations.AddField(
            model_name='eventcontentlistingitem',
            name='limit_to_types',
            field=models.ManyToManyField(help_text=b'Leave empty to show all events.', to='icekit_events.EventType', db_table=b'ik_event_listing_types', blank=True),
        ),
        migrations.AddField(
            model_name='eventcontentlistingitem',
            name='to_date',
            field=models.DateTimeField(help_text=b'Only show events with occurrences that start before this date and time.', null=True, blank=True),
        ),
        migrations.AddField(
            model_name='eventcontentlistingitem',
            name='to_days_ahead',
            field=models.IntegerField(help_text=b'Only show events with occurrences before this number of days into the future. Set this to zero to show only events with past occurrences.', null=True, blank=True),
        ),
    ]
