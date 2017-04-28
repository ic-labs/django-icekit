# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('search_page', '0005_auto_20161125_1720'),
    ]

    operations = [
        migrations.AddField(
            model_name='searchpage',
            name='default_search_type',
            field=models.CharField(max_length=255, blank=True, help_text=b"Default to a top-level result type, e.g 'Education'. This value must be one of the top-level facets."),
        ),
    ]
