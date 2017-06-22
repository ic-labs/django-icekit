# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0021_merge'),
    ]

    operations = [
        migrations.AlterField(
            model_name='image',
            name='external_ref',
            field=models.CharField(blank=True, help_text='The reference for this image in a 3rd-party system', max_length=1024),
        ),
    ]
