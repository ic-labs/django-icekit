# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0012_imagerepurposeconfig_is_cropping_allowed'),
    ]

    operations = [
        migrations.AddField(
            model_name='image',
            name='is_cropping_allowed',
            field=models.BooleanField(help_text=b'Can this image be cropped?', default=False),
        ),
    ]
