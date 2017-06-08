# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0014_eventbase_human_times'),
    ]

    operations = [
        migrations.RenameField(
            model_name='occurrence',
            old_name='is_user_modified',
            new_name='is_protected_from_regeneration',
        ),
    ]
