# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


def forwards_migration(apps, schema_editor):
    """
    "0002_recurrence_rules" added malformed recurrence with trailing
    semi-colons. While the JS parser on the front-end handles them,
    the python parser will crash
    """
    RecurrenceRule = apps.get_model('icekit_events', 'RecurrenceRule')
    for rrule in RecurrenceRule.objects.all():
        if ';\n' in rrule.recurrence_rule:
            parts = rrule.recurrence_rule.split(';\n')
            rrule.recurrence_rule = '\n'.join(parts)
            rrule.save()


def reverse_migration(apps, schema_editor):
    pass


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0028_eventbase_price_detailed'),
    ]

    operations = [
        migrations.RunPython(forwards_migration, reverse_migration),
    ]
