# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import edtf.fields


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0028_auto_20170523_1141'),
    ]

    operations = [
        migrations.RenameField(
            model_name='creatorbase',
            old_name='external_identifier',
            new_name='external_ref',
        ),
        migrations.RenameField(
            model_name='workbase',
            old_name='external_identifier',
            new_name='external_ref',
        ),
    ]
