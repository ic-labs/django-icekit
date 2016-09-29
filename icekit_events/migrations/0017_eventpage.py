# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0016_auto_20160929_1504'),
    ]

    operations = [
        migrations.CreateModel(
            name='EventPage',
            fields=[
                ('event_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='icekit_events.Event')),
                ('slug', models.SlugField(max_length=255)),
            ],
            options={
                'ordering': ('title', 'pk'),
                'abstract': False,
            },
            bases=('icekit_events.event',),
        ),
    ]
