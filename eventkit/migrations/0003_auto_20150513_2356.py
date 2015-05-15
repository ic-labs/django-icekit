# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('eventkit', '0002_auto_20150512_0429'),
    ]

    operations = [
        migrations.CreateModel(
            name='RecurrenceRule',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created', models.DateTimeField(default=django.utils.timezone.now, editable=False, db_index=True)),
                ('modified', models.DateTimeField(default=django.utils.timezone.now, editable=False, db_index=True)),
                ('description', models.TextField(help_text=b'Unique.', unique=True, max_length=255)),
                ('recurrence_rule', models.TextField(help_text=b'An iCalendar (RFC2445) recurrence rule that defines when an event repeats.')),
            ],
            options={
                'ordering': ('-id',),
                'abstract': False,
                'get_latest_by': 'pk',
            },
        ),
        migrations.RemoveField(
            model_name='event',
            name='repeat_expression',
        ),
        migrations.AddField(
            model_name='event',
            name='custom_recurrence_rule',
            field=models.TextField(help_text=b'A custom iCalendar (RFC2445) recurrence rule that defines when this event repeats.', max_length=255, null=True, blank=True),
        ),
        migrations.AddField(
            model_name='event',
            name='recurrence_rule',
            field=models.ForeignKey(blank=True, to='eventkit.RecurrenceRule', null=True),
        ),
    ]
