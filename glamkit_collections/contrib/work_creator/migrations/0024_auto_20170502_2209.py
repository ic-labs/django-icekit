# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0023_auto_20170522_1508'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='creatorbase',
            options={'ordering': ('name_sort', 'slug', 'publishing_is_draft'), 'verbose_name': 'creator'},
        ),
        migrations.AlterModelOptions(
            name='workbase',
            options={'ordering': ('slug', 'publishing_is_draft'), 'verbose_name': 'work'},
        ),
    ]
