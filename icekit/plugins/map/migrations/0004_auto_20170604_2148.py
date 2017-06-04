# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_map', '0003_auto_20170531_1359'),
    ]

    operations = [
        migrations.AlterField(
            model_name='mapitem',
            name='_embed_code',
            field=models.TextField(verbose_name=b'Embed code', help_text=b'Embed code sourced from Google Maps. See <a href="https://support.google.com/maps/answer/144361">https://support.google.com/maps/answer/144361</a>'),
        ),
    ]
