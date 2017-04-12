# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0014_auto_20170412_1745'),
    ]

    operations = [
        migrations.RenameField(
            model_name='workorigin',
            old_name='sort',
            new_name='order',
        ),
    ]
