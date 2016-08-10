# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import polymorphic_tree.models
import timezone.timezone
from .. import models as icekit_events_models


class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('modified', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('title', models.CharField(max_length=255)),
                ('all_day', models.BooleanField(default=False)),
                ('starts', models.DateTimeField(default=icekit_events_models.default_starts)),
                ('ends', models.DateTimeField(default=icekit_events_models.default_ends)),
                ('recurrence_rule', icekit_events_models.RecurrenceRuleField(help_text='An iCalendar (RFC2445) recurrence rule that defines when this event repeats.', null=True, blank=True)),
                ('end_repeat', models.DateTimeField(help_text='If empty, this event will repeat indefinitely.', null=True, blank=True)),
                ('is_repeat', models.BooleanField(default=True)),
                ('lft', models.PositiveIntegerField(editable=False, db_index=True)),
                ('rght', models.PositiveIntegerField(editable=False, db_index=True)),
                ('tree_id', models.PositiveIntegerField(editable=False, db_index=True)),
                ('level', models.PositiveIntegerField(editable=False, db_index=True)),
                ('parent', polymorphic_tree.models.PolymorphicTreeForeignKey(related_name='children', blank=True, to='icekit_events.Event', null=True)),
                ('polymorphic_ctype', models.ForeignKey(related_name='polymorphic_icekit_events.event_set+', editable=False, to='contenttypes.ContentType', null=True)),
            ],
            options={
                'abstract': False,
                # Legacy table name
                'db_table': 'eventkit_event',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='RecurrenceRule',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('modified', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('description', models.TextField(help_text=b'Unique.', unique=True, max_length=255)),
                ('recurrence_rule', icekit_events_models.RecurrenceRuleField(help_text='An iCalendar (RFC2445) recurrence rule that defines when an event repeats. Unique.', unique=True)),
            ],
            options={
                'ordering': ('-id',),
                'abstract': False,
                'get_latest_by': 'pk',
                # Legacy table name
                'db_table': 'eventkit_recurrencerule',
            },
            bases=(models.Model,),
        ),
        migrations.AlterUniqueTogether(
            name='event',
            unique_together=set([('starts', 'parent')]),
        ),
    ]
