# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0015_auto_20160803_0011'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='occurrence',
            name='is_generated',
        ),
        migrations.AlterField(
            model_name='occurrence',
            name='cancel_reason',
            field=models.CharField(max_length=255, null=True, blank=True),
        ),
    ]
