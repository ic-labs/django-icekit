# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='SimpleEvent',
            fields=[
                ('eventbase_ptr', models.OneToOneField(auto_created=True, parent_link=True, primary_key=True, to='icekit_events.EventBase', serialize=False)),
            ],
            options={
                'verbose_name': 'Simple event',
            },
            bases=('icekit_events.eventbase',),
        ),
    ]
