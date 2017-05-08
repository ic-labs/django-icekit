# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0017_workbase_origin_locations'),
    ]

    operations = [
        migrations.AddField(
            model_name='workbase',
            name='external_ref',
            field=models.CharField(blank=True, max_length=255, verbose_name=b'External reference', null=True, help_text=b'The reference identifier used by external data source.'),
        ),
    ]
