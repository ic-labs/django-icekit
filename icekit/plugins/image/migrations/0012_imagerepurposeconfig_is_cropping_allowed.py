# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0011_auto_20170310_1853'),
    ]

    operations = [
        migrations.AddField(
            model_name='imagerepurposeconfig',
            name='is_cropping_allowed',
            field=models.BooleanField(help_text=b'Can we crop the image to be exactly width x height?', default=False),
        ),
    ]
