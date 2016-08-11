# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0004_auto_20151001_2023'),
    ]

    operations = [
        migrations.AddField(
            model_name='imageitem',
            name='caption_override',
            field=models.TextField(blank=True),
            preserve_default=True,
        ),
    ]
