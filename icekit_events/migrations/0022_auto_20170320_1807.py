# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0021_merge'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventbase',
            name='primary_type',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, related_name='events', blank=True, to='icekit_events.EventType', help_text=b"The primary category of this event: Talk, workshop, etc. Only 'public' event categories can be primary.", verbose_name=b'Primary category', null=True),
        ),
        migrations.AlterField(
            model_name='eventbase',
            name='secondary_types',
            field=models.ManyToManyField(related_name='secondary_events', help_text=b"Additional or internal categories: Education or members events, for example. Events show in listings for <em>every</em> category they're associated with.", blank=True, to='icekit_events.EventType', verbose_name=b'Secondary categories'),
        ),
    ]
