# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone
import eventkit.models


class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created', models.DateTimeField(default=django.utils.timezone.now, editable=False, db_index=True)),
                ('modified', models.DateTimeField(default=django.utils.timezone.now, editable=False, db_index=True)),
                ('title', models.CharField(max_length=255)),
                ('all_day', models.BooleanField(default=False)),
                ('starts', models.DateTimeField(default=eventkit.models.default_starts)),
                ('ends', models.DateTimeField(default=eventkit.models.default_ends)),
                ('repeat_expression', models.CharField(help_text=b'A cron expression that defines when this event repeats.', max_length=255)),
                ('end_repeat', models.DateTimeField(help_text=b'If empty, this event will repeat indefinitely.', null=True)),
                ('original', models.ForeignKey(editable=False, to='eventkit.Event', null=True)),
                ('polymorphic_ctype', models.ForeignKey(related_name='polymorphic_eventkit.event_set+', editable=False, to='contenttypes.ContentType', null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.AlterUniqueTogether(
            name='event',
            unique_together=set([('starts', 'original')]),
        ),
    ]
