# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0005_auto_20161024_1742'),
    ]

    operations = [
        migrations.CreateModel(
            name='EventType',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('is_public', models.BooleanField(default=True, help_text=b"Public types are displayed to the public, e.g. 'talk', 'workshop', etc. Non-public types are used to indicate special behaviour, such as education or members events.", verbose_name=b'Show to public?')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.AddField(
            model_name='eventbase',
            name='primary_type',
            field=models.ForeignKey(to='icekit_events.EventType', blank=True, related_name='events', help_text=b'The primary type of this event: Talk, workshop, etc. Only public Event Types can be primary.', null=True),
        ),
        migrations.AddField(
            model_name='eventbase',
            name='secondary_types',
            field=models.ManyToManyField(related_name='secondary_events', to='icekit_events.EventType', help_text=b'Additional/internal types: Education or members events, for example.', blank=True),
        ),
    ]
