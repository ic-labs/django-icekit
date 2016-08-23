# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0002_auto_20150527_0022'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='imageitem',
            options={'verbose_name': 'Image', 'verbose_name_plural': 'Images'},
        ),
    ]
