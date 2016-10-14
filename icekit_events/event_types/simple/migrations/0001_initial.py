# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0018_auto_20160929_2106'),
    ]

    operations = [
        migrations.CreateModel(
            name='SimpleEvent',
            fields=[
                ('event_ptr', models.OneToOneField(serialize=False, primary_key=True, auto_created=True, parent_link=True, to='icekit_events.Event')),
            ],
            options={
                'abstract': False,
                'ordering': ('title', 'pk'),
            },
            bases=('icekit_events.event',),
        ),
    ]
