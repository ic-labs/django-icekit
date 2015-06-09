# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('eventkit', '0004_auto_20150607_2336'),
        ('icekit', '0002_layout'),
    ]

    operations = [
        migrations.CreateModel(
            name='Exhibition',
            fields=[
                ('event_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='eventkit.Event')),
                ('events', models.ManyToManyField(help_text=b'Events that belong to this exhibition.', related_name='exhibitions', to='eventkit.Event', blank=True)),
                ('layout', models.ForeignKey(related_name='eventkit_exhibition_exhibition_related', blank=True, to='icekit.Layout', null=True)),
            ],
            options={
                'abstract': False,
            },
            bases=('eventkit.event', models.Model),
        ),
    ]
