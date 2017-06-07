# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0006_auto_20161026_2259'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='workimage',
            options={'ordering': ('order',), 'verbose_name': 'Image'},
        ),
    ]
