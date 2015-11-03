# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('brightcove', '0002_auto_20150527_0022'),
    ]

    operations = [
        migrations.AddField(
            model_name='brightcoveitem',
            name='is_four_three',
            field=models.BooleanField(default=False, help_text=b'Does this video have a 4:3 ratio?'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='brightcoveitem',
            name='is_full_width',
            field=models.BooleanField(default=False),
            preserve_default=True,
        ),
    ]
