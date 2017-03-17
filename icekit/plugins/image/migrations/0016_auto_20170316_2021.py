# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0015_auto_20170310_2004'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='imagerepurposeconfig',
            options={'verbose_name': 'Image derivative'},
        ),
    ]
