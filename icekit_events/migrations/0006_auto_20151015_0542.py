# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from timezone import timezone


def forwards(apps, schema_editor):
    Event = apps.get_model('icekit_events', 'Event')
    for event in Event.objects.all():
        event.date_starts = timezone.date(event.starts)
        event.date_ends = timezone.date(event.ends)
        if event.all_day:
            event.starts = event.ends = None
        event.save()


def backwards(apps, schema_editor):
    Event = apps.get_model('icekit_events', 'Event')
    for event in Event.objects.all():
        if not event.all_day:
            event.starts = timezone.datetime(
                *event.date_starts.timetuple()[:3])
            event.ends = timezone.datetime(*event.date_ends.timetuple()[:3])
        event.save()


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0005_auto_20151015_0540'),
    ]

    operations = [
        migrations.RunPython(forwards, backwards),
        migrations.AlterField(
            model_name='event',
            name='date_ends',
            field=models.DateField(),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='event',
            name='date_starts',
            field=models.DateField(),
            preserve_default=True,
        ),
    ]
