# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('text', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='textitem',
            name='style',
            field=models.CharField(blank=True, max_length=255, choices=[(b'', b'Normal')]),
        ),
    ]
