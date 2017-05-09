# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('text', '0003_auto_20170206_1325'),
    ]

    operations = [
        migrations.AlterField(
            model_name='textitem',
            name='style',
            field=models.CharField(blank=True, max_length=255, choices=[(b'', b'Normal')]),
        ),
    ]
