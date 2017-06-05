# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_map', '0002_auto_20160821_2140'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='mapitem',
            name='share_url',
        ),
        migrations.AddField(
            model_name='mapitem',
            name='_cleaned_embed_code',
            field=models.TextField(blank=True, editable=False),
        ),
        migrations.AddField(
            model_name='mapitem',
            name='_embed_code',
            field=models.TextField(default=' ', help_text=b'Embed code sourced from Google Maps. See https://support.google.com/maps/answer/144361'),
            preserve_default=False,
        ),
    ]
