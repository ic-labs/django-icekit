# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import polymorphic_tree.models
import django.db.models.deletion
import timezone.timezone
import icekit_events.models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0012_auto_20160706_1606'),
    ]

    operations = [
        migrations.CreateModel(
            name='EventRepeatsGenerator',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('modified', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('recurrence_rule', icekit_events.models.RecurrenceRuleField(help_text='An iCalendar (RFC2445) recurrence rule that defines when this event repeats.', null=True, blank=True)),
                ('start', models.DateTimeField(default=icekit_events.models.default_starts, db_index=True)),
                ('end', models.DateTimeField(default=icekit_events.models.default_ends, db_index=True)),
                ('is_all_day', models.BooleanField(default=False, db_index=True)),
                ('repeat_end', models.DateTimeField(help_text='If empty, this event will repeat indefinitely.', null=True, blank=True)),
            ],
            options={
                'ordering': ['pk'],
            },
        ),
        migrations.CreateModel(
            name='Occurrence',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('modified', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('start', models.DateTimeField(db_index=True)),
                ('end', models.DateTimeField(db_index=True)),
                ('is_all_day', models.BooleanField(default=False, db_index=True)),
                ('is_user_modified', models.BooleanField(default=False, db_index=True)),
                ('is_cancelled', models.BooleanField(default=False)),
                ('is_hidden', models.BooleanField(default=False)),
                ('cancel_reason', models.CharField(max_length=255, null=True, blank=True)),
                ('original_start', models.DateTimeField(null=True, editable=False, blank=True)),
                ('original_end', models.DateTimeField(null=True, editable=False, blank=True)),
            ],
            options={
                'ordering': ['start', '-is_all_day', 'event', 'pk'],
            },
        ),
        migrations.AlterModelOptions(
            name='event',
            options={'ordering': ('title', 'pk')},
        ),
        migrations.RemoveField(
            model_name='event',
            name='level',
        ),
        migrations.RemoveField(
            model_name='event',
            name='lft',
        ),
        migrations.RenameField(
            model_name='event',
            old_name='parent',
            new_name='derived_from',
        ),
        migrations.RemoveField(
            model_name='event',
            name='rght',
        ),
        migrations.RemoveField(
            model_name='event',
            name='tree_id',
        ),
        migrations.AddField(
            model_name='event',
            name='publishing_is_draft',
            field=models.BooleanField(default=True, db_index=True, editable=False),
        ),
        migrations.AddField(
            model_name='event',
            name='publishing_linked',
            field=models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='icekit_events.Event'),
        ),
        migrations.AddField(
            model_name='event',
            name='publishing_modified_at',
            field=models.DateTimeField(default=django.utils.timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='event',
            name='publishing_published_at',
            field=models.DateTimeField(null=True, editable=False),
        ),
        migrations.AddField(
            model_name='occurrence',
            name='event',
            field=polymorphic_tree.models.PolymorphicTreeForeignKey(related_name='occurrences', editable=False, to='icekit_events.Event'),
        ),
        migrations.AddField(
            model_name='occurrence',
            name='generator',
            field=models.ForeignKey(blank=True, to='icekit_events.EventRepeatsGenerator', null=True),
        ),
        migrations.AddField(
            model_name='eventrepeatsgenerator',
            name='event',
            field=polymorphic_tree.models.PolymorphicTreeForeignKey(related_name='repeat_generators', editable=False, to='icekit_events.Event'),
        ),
    ]
