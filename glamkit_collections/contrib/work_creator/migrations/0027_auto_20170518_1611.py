# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0026_auto_20170516_1518'),
    ]

    operations = [
        migrations.AlterField(
            model_name='workbase',
            name='title',
            field=models.CharField(help_text=b'The official title of this object. Includes series title when appropriate.', max_length=511),
        ),
    ]
