# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('eventkit', '0004_auto_20150607_2336'),
    ]

    operations = [
        migrations.CreateModel(
            name='FluentEvent',
            fields=[
                ('event_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='eventkit.Event')),
            ],
            options={
                'abstract': False,
            },
            bases=('eventkit.event',),
        ),
    ]
