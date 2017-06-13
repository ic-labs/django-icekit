# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_press_releases', '0009_auto_20170519_1308'),
    ]

    operations = [
        migrations.AddField(
            model_name='pressrelease',
            name='admin_notes',
            field=models.TextField(blank=True, help_text=b"Administrator's notes about this content"),
        ),
        migrations.AddField(
            model_name='pressrelease',
            name='brief',
            field=models.TextField(blank=True, help_text=b'A document brief describing the purpose of this content'),
        ),
    ]
