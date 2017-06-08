# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0002_workbase_department'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='creatorbase',
            options={'ordering': ('name_sort', 'slug'), 'verbose_name': 'creator'},
        ),
        migrations.RemoveField(
            model_name='workbase',
            name='thumbnail_override',
        ),
    ]
