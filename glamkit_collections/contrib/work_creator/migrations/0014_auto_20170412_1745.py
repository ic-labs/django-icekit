# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0013_auto_20170412_1724'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='workbase',
            name='origin_city',
        ),
        migrations.RemoveField(
            model_name='workbase',
            name='origin_colloquial',
        ),
        migrations.RemoveField(
            model_name='workbase',
            name='origin_continent',
        ),
        migrations.RemoveField(
            model_name='workbase',
            name='origin_country',
        ),
        migrations.RemoveField(
            model_name='workbase',
            name='origin_neighborhood',
        ),
        migrations.RemoveField(
            model_name='workbase',
            name='origin_state_province',
        ),
    ]
