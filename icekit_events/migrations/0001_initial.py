# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import icekit.fields
import django.db.models.deletion
import timezone.timezone
import icekit_events.models
from datetime import datetime

class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
    ]

    operations = [
        migrations.CreateModel(
            name='EventBase',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('publishing_is_draft', models.BooleanField(editable=False, db_index=True, default=True)),
                ('publishing_modified_at', models.DateTimeField(editable=False, default=django.utils.timezone.now)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('created', models.DateTimeField(editable=False, db_index=True, default=timezone.timezone.now)),
                ('modified', models.DateTimeField(editable=False, db_index=True, default=timezone.timezone.now)),
                ('show_in_calendar', models.BooleanField(help_text='Show this event in the public calendar', default=True)),
                ('human_dates', models.TextField(blank=True, help_text='Describe event dates in everyday language, e.g. "Every Sunday in March".')),
                ('special_instructions', models.TextField(blank=True, help_text='Describe special instructions for attending event, e.g. "Enter via the Jones St entrance".')),
                ('cta_text', models.CharField(blank=True, verbose_name='Call to action', max_length=255, default='Book now')),
                ('cta_url', icekit.fields.ICEkitURLField(blank=True, null=True, verbose_name='CTA URL', max_length=300, help_text='The URL where visitors can arrange to attend an event by purchasing tickets or RSVPing.')),
                ('derived_from', models.ForeignKey(blank=True, related_name='derivitives', to='icekit_events.EventBase', editable=False, null=True)),
                ('polymorphic_ctype', models.ForeignKey(related_name='polymorphic_icekit_events.eventbase_set+', to='contenttypes.ContentType', editable=False, null=True)),
                ('publishing_linked', models.OneToOneField(on_delete=django.db.models.deletion.SET_NULL, related_name='publishing_draft', to='icekit_events.EventBase', editable=False, null=True)),
            ],
            options={
                'verbose_name': 'Event',
                'ordering': ('title', 'pk'),
            },
        ),
        migrations.CreateModel(
            name='EventRepeatsGenerator',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('created', models.DateTimeField(editable=False, db_index=True, default=timezone.timezone.now)),
                ('modified', models.DateTimeField(editable=False, db_index=True, default=timezone.timezone.now)),
                ('recurrence_rule', icekit_events.models.RecurrenceRuleField(blank=True, null=True, help_text='An iCalendar (RFC2445) recurrence rule that defines when this event repeats.')),
                ('start', models.DateTimeField(verbose_name=b'first start', db_index=True, default=datetime.now)),
                ('end', models.DateTimeField(verbose_name=b'first end', db_index=True, default=datetime.now)),
                ('is_all_day', models.BooleanField(db_index=True, default=False)),
                ('repeat_end', models.DateTimeField(blank=True, null=True, help_text='If empty, this event will repeat indefinitely.')),
                ('event', models.ForeignKey(related_name='repeat_generators', to='icekit_events.EventBase', editable=False)),
            ],
            options={
                'ordering': ['pk'],
            },
        ),
        migrations.CreateModel(
            name='Occurrence',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('created', models.DateTimeField(editable=False, db_index=True, default=timezone.timezone.now)),
                ('modified', models.DateTimeField(editable=False, db_index=True, default=timezone.timezone.now)),
                ('start', models.DateTimeField(db_index=True)),
                ('end', models.DateTimeField(db_index=True)),
                ('is_all_day', models.BooleanField(db_index=True, default=False)),
                ('is_user_modified', models.BooleanField(db_index=True, default=False)),
                ('is_cancelled', models.BooleanField(default=False)),
                ('is_hidden', models.BooleanField(default=False)),
                ('cancel_reason', models.CharField(blank=True, null=True, max_length=255)),
                ('original_start', models.DateTimeField(blank=True, null=True, editable=False)),
                ('original_end', models.DateTimeField(blank=True, null=True, editable=False)),
                ('event', models.ForeignKey(related_name='occurrences', to='icekit_events.EventBase', editable=False)),
                ('generator', models.ForeignKey(blank=True, to='icekit_events.EventRepeatsGenerator', null=True)),
            ],
            options={
                'ordering': ['start', '-is_all_day', 'event', 'pk'],
            },
        ),
        migrations.CreateModel(
            name='RecurrenceRule',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('created', models.DateTimeField(editable=False, db_index=True, default=timezone.timezone.now)),
                ('modified', models.DateTimeField(editable=False, db_index=True, default=timezone.timezone.now)),
                ('description', models.TextField(unique=True, help_text=b'Unique.', max_length=255)),
                ('recurrence_rule', icekit_events.models.RecurrenceRuleField(help_text='An iCalendar (RFC2445) recurrence rule that defines when an event repeats. Unique.', unique=True)),
            ],
            options={
                'get_latest_by': 'pk',
                'abstract': False,
                'ordering': ('-id',),
            },
        ),
    ]
