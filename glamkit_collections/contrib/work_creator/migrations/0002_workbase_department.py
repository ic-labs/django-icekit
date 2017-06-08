# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='workbase',
            name='department',
            field=models.CharField(max_length=255, blank=True, help_text=b'The curatorial unit responsible for the object, e.g., "Western Painting."'),
        ),
    ]
