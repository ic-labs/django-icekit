# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import datetime
import polymorphic_tree.models
from django.utils.timezone import utc
import timezone.timezone
import icekit_events.models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0014_auto_20160728_1645'),
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
                'ordering': ('start', '-is_all_day', 'event__title', 'pk'),
            },
        ),
        migrations.AlterModelOptions(
            name='event',
            options={'ordering': ('title', 'pk')},
        ),
        migrations.AlterModelOptions(
            name='occurrence',
            options={'ordering': ['start']},
        ),
        migrations.RenameField(
            model_name='occurrence',
            old_name='deleted_reason',
            new_name='cancel_reason',
        ),
        migrations.RenameField(
            model_name='occurrence',
            old_name='is_deleted',
            new_name='is_cancelled',
        ),
        migrations.RemoveField(
            model_name='event',
            name='parent',
        ),
        migrations.RemoveField(
            model_name='occurrence',
            name='ends',
        ),
        migrations.RemoveField(
            model_name='occurrence',
            name='starts',
        ),
        migrations.AddField(
            model_name='event',
            name='derived_from',
            field=polymorphic_tree.models.PolymorphicTreeForeignKey(related_name='derivitives', blank=True, editable=False, to='icekit_events.Event', null=True),
        ),
        migrations.AddField(
            model_name='occurrence',
            name='end',
            field=models.DateTimeField(default=datetime.datetime(2016, 8, 2, 14, 10, 56, 766215, tzinfo=utc), db_index=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='occurrence',
            name='is_all_day',
            field=models.BooleanField(default=False, db_index=True),
        ),
        migrations.AddField(
            model_name='occurrence',
            name='start',
            field=models.DateTimeField(default=datetime.datetime(2016, 8, 2, 14, 11, 0, 4346, tzinfo=utc), db_index=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='eventrepeatsgenerator',
            name='event',
            field=polymorphic_tree.models.PolymorphicTreeForeignKey(related_name='repeat_generators', editable=False, to='icekit_events.Event'),
        ),
        migrations.AddField(
            model_name='occurrence',
            name='generator',
            field=models.ForeignKey(blank=True, to='icekit_events.EventRepeatsGenerator', null=True),
        ),
    ]
