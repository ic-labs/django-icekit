# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0034_workcategory'),
        ('gk_collections_artwork', '0003_auto_20180126_1346'),
    ]

    operations = [
        migrations.AddField(
            model_name='artwork',
            name='category',
            field=models.ForeignKey(help_text=b'A broad category that the work belongs to, e.g., "Painting", "Sculpture"', blank=True, null=True, to='gk_collections_work_creator.WorkCategory'),
        ),
    ]
