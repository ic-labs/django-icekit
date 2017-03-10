# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0006_auto_20150911_0744'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='mediacategory',
            options={'verbose_name_plural': 'Asset categories', 'verbose_name': 'Asset category'},
        ),
    ]
