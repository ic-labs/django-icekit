# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0014_eventbase_human_times'),
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='TodaysOccurrences',
            fields=[
                ('contentitem_ptr', models.OneToOneField(to='fluent_contents.ContentItem', primary_key=True, auto_created=True, parent_link=True, serialize=False)),
                ('include_finished', models.BooleanField(default=False, help_text=b'include occurrences that have already finished today')),
                ('types_to_show', models.ManyToManyField(blank=True, db_table=b'ik_todays_occurrences_types', to='icekit_events.EventType', help_text=b'Leave empty to show all events.')),
            ],
            options={
                'verbose_name': "Today's events",
                'db_table': 'contentitem_ik_events_todays_occurrences_todaysoccurrences',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
