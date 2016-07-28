# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0013_occurrence'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='event',
            name='level',
        ),
        migrations.RemoveField(
            model_name='event',
            name='lft',
        ),
        migrations.RemoveField(
            model_name='event',
            name='rght',
        ),
        migrations.RemoveField(
            model_name='event',
            name='tree_id',
        ),
    ]
