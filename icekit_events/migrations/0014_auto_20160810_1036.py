# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import polymorphic_tree.models


def halt_if_unmigrated_legacy_data(apps, schema_editor):
    """
    Perform some basic sanity-checks on existing Event data to check that there
    are not legacy records remaining that have not yet been migrated to the
    new model relationships and DB fields.
    """
    from icekit_events.models import coerce_dt_awareness, zero_datetime
    Event = apps.get_model("icekit_events", "Event")
    # Check no `is_repeat` legacy records remain
    qs = Event.objects.filter(is_repeat=True)
    if qs:
        raise Exception(
            "Aborting DB migration as unmigrated legacy data is present"
            " - Event records exist with `is_repeat==True`: {0}"
            .format(qs.all())
        )
    # Check all repeating legacy events have a corresponding generator
    qs = Event.objects.filter(recurrence_rule__isnull=False)
    for event in qs.all():
        if not event.repeat_generators.filter(
            recurrence_rule=event.recurrence_rule
        ):
            raise Exception(
                "Aborting DB migration as unmigrated legacy data is present"
                " - Event record {0} has a legacy `recurrence_rule` without"
                " a corresponding new `EventRepeatsGenerator`"
                .format(event.pk)
            )
    # Check all non-repeating legacy events have a single occurrence matching
    # the expected start time/date
    qs = Event.objects.filter(recurrence_rule__isnull=True)
    for event in qs.all():
        if event.all_day:
            event_starts = zero_datetime(
                coerce_dt_awareness(event.date_starts))
        else:
            event_starts = event.starts
        if not event.occurrences.filter(start=event_starts):
            raise Exception(
                "Aborting DB migration as unmigrated legacy data is present"
                " - Event record {0} has a legacy start time/date without"
                " a corresponding new `Occurrence`"
                .format(event.pk)
            )


def noop(apps, schema_editor):
    pass


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0013_auto_20160809_1215'),
    ]

    operations = [
        migrations.RunPython(
            halt_if_unmigrated_legacy_data,
            reverse_code=noop),
        migrations.RemoveField(
            model_name='event',
            name='all_day',
        ),
        migrations.RemoveField(
            model_name='event',
            name='date_end_repeat',
        ),
        migrations.RemoveField(
            model_name='event',
            name='date_ends',
        ),
        migrations.RemoveField(
            model_name='event',
            name='date_starts',
        ),
        migrations.RemoveField(
            model_name='event',
            name='end_repeat',
        ),
        migrations.RemoveField(
            model_name='event',
            name='ends',
        ),
        migrations.RemoveField(
            model_name='event',
            name='is_repeat',
        ),
        migrations.RemoveField(
            model_name='event',
            name='recurrence_rule',
        ),
        migrations.RemoveField(
            model_name='event',
            name='starts',
        ),
        migrations.AlterField(
            model_name='event',
            name='derived_from',
            field=polymorphic_tree.models.PolymorphicTreeForeignKey(related_name='derivitives', blank=True, editable=False, to='icekit_events.Event', null=True),
        ),
    ]
