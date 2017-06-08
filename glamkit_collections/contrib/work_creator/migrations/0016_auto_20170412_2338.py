# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0015_auto_20170412_1816'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='workorigin',
            options={'ordering': ('order',)},
        ),
    ]
