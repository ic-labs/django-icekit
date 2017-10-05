# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_location', '0005_auto_20170905_1136'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='location',
            options={'ordering': ('title',)},
        ),
    ]
