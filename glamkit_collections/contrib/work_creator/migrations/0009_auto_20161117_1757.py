# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0008_auto_20161114_1240'),
    ]

    operations = [
        migrations.RenameField(
            model_name='workbase',
            old_name='one_liner',
            new_name='oneliner',
        ),
    ]
