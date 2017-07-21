# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0026_eventbase_location'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventbase',
            name='location',
            field=models.ForeignKey(null=True, to='icekit_plugins_location.Location', blank=True, on_delete=django.db.models.deletion.SET_NULL, related_name='events'),
        ),
    ]
