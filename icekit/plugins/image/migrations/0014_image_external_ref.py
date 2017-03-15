# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0013_image_is_cropping_allowed'),
    ]

    operations = [
        migrations.AddField(
            model_name='image',
            name='external_ref',
            field=models.CharField(max_length=255, help_text='The reference for this image in a 3rd-party system', blank=True),
        ),
    ]
