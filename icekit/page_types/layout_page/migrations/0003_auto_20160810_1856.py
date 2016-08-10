# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('layout_page', '0002_auto_20160419_2209'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='layoutpage',
            options={'verbose_name': 'Layout page'},
        ),
    ]
