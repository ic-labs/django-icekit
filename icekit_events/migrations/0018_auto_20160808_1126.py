# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0017_auto_20160804_1342'),
    ]

    operations = [
        migrations.AddField(
            model_name='occurrence',
            name='original_end',
            field=models.DateTimeField(null=True, editable=False, blank=True),
        ),
        migrations.AddField(
            model_name='occurrence',
            name='original_start',
            field=models.DateTimeField(null=True, editable=False, blank=True),
        ),
    ]
