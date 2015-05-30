# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import eventkit.models


def forwards(apps, schema_editor):
    Event = apps.get_model('eventkit', 'Event')
    for event in Event.objects.exclude(recurrence_rule=None):
        event.custom_recurrence_rule = event.recurrence_rule.recurrence_rule
        event.recurrence_rule = None
        event.save()


def backwards(apps, schema_editor):
    Event = apps.get_model('eventkit', 'Event')
    RecurrenceRule = apps.get_model('eventkit', 'RecurrenceRule')
    for recurrence_rule in RecurrenceRule.objects.all():
        Event.objects \
            .filter(custom_recurrence_rule=recurrence_rule.recurrence_rule) \
            .update(
                recurrence_rule=recurrence_rule,
                custom_recurrence_rule=None
            )


class Migration(migrations.Migration):

    dependencies = [
        ('eventkit', '0005_auto_20150528_1433'),
    ]

    operations = [
        migrations.RunPython(forwards, backwards),
        migrations.RemoveField(
            model_name='event',
            name='recurrence_rule',
        ),
        migrations.RenameField(
            model_name='event',
            old_name='custom_recurrence_rule',
            new_name='recurrence_rule',
        ),
    ]
