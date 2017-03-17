# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0016_auto_20170314_1306'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='imagerepurposeconfig',
            options={'ordering': ('id',), 'verbose_name': 'Image derivative'},
        ),
    ]
