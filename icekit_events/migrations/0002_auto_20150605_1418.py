# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


RULES = [
    ('Daily', 'RRULE:FREQ=DAILY'),
    ('Daily, Weekdays', 'RRULE:FREQ=DAILY;BYDAY=MO,TU,WE,TH,FR'),
    ('Daily, Weekends', 'RRULE:FREQ=DAILY;BYDAY=SA,SU'),
    ('Weekly', 'RRULE:FREQ=WEEKLY'),
    ('Monthly', 'RRULE:FREQ=MONTHLY'),
    ('Yearly', 'RRULE:FREQ=YEARLY'),
]


def forwards(apps, schema_editor):
    """
    Create initial recurrence rules.
    """
    RecurrenceRule = apps.get_model('icekit_events', 'RecurrenceRule')
    for description, recurrence_rule in RULES:
        RecurrenceRule.objects.get_or_create(
            description=description,
            defaults=dict(recurrence_rule=recurrence_rule),
        )


def backwards(apps, schema_editor):
    """
    Delete initial recurrence rules.
    """
    RecurrenceRule = apps.get_model('icekit_events', 'RecurrenceRule')
    descriptions = [d for d, rr in RULES]
    RecurrenceRule.objects.filter(description__in=descriptions).delete()


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(forwards, backwards),
    ]
