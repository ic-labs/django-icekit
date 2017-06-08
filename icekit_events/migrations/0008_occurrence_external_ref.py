# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0007_type_fixtures'),
    ]

    operations = [
        migrations.AddField(
            model_name='occurrence',
            name='external_ref',
            field=models.CharField(max_length=255, blank=True, null=True),
        ),
    ]
