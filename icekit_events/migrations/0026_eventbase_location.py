# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_location', '0001_initial'),
        ('icekit_events', '0025_auto_20170519_1327'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventbase',
            name='location',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='events', to='icekit_plugins_location.Location'),
        ),
    ]
