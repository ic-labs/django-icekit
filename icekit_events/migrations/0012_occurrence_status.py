# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0011_auto_20161128_1049'),
    ]

    operations = [
        migrations.AddField(
            model_name='occurrence',
            name='status',
            field=models.CharField(max_length=255, null=True, blank=True),
        ),
    ]
