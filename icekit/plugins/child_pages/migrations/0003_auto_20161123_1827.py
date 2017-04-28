# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_child_pages', '0002_auto_20160821_2140'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='childpageitem',
            options={'verbose_name': 'Child Pages'},
        ),
    ]
