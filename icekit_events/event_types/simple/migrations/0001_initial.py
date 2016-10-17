# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0017_rename_event_to_eventbase'),
    ]

    operations = [
        migrations.CreateModel(
            name='SimpleEvent',
            fields=[
                ('eventbase_ptr', models.OneToOneField(serialize=False, primary_key=True, auto_created=True, parent_link=True, to='icekit_events.EventBase')),
            ],
            options={
                'abstract': False,
                'ordering': ('title', 'pk'),
                'verbose_name': 'Simple event',
            },
            bases=('icekit_events.eventbase',),
        ),
    ]
