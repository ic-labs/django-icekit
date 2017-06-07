# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import edtf.fields


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0027_auto_20170518_1611'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='workbase',
            name='external_ref',
        ),
    ]
