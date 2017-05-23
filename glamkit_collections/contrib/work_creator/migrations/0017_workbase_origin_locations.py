# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_collections', '0003_auto_20170412_1742'),
        ('gk_collections_work_creator', '0016_auto_20170412_2338'),
    ]

    operations = [
        migrations.AddField(
            model_name='workbase',
            name='origin_locations',
            field=models.ManyToManyField(through='gk_collections_work_creator.WorkOrigin', to='glamkit_collections.GeographicLocation'),
        ),
    ]
