# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('layout_page', '0006_auto_20161130_1109'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='layoutpage',
            options={'verbose_name': 'Page'},
        ),
    ]
