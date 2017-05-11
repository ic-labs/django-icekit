# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


RULES = [
    ('Daily, except Xmas day', 'RRULE:FREQ=DAILY;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25'),
    ('Daily, Weekdays, except Xmas day',
     'RRULE:FREQ=DAILY;BYDAY=MO,TU,WE,TH,FR;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25'),
    ('Daily, Weekends, except Xmas day', 'RRULE:FREQ=DAILY;BYDAY=SA,SU;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25'),
    ('Weekly, except Xmas day', 'RRULE:FREQ=WEEKLY;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25'),
    ('Monthly, except Xmas day', 'RRULE:FREQ=MONTHLY;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25'),
    ('Yearly, except Xmas day', 'RRULE:FREQ=YEARLY;\nEXRULE:FREQ=YEARLY;BYMONTH=12;BYMONTHDAY=25'),
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
