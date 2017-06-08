# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0010_auto_20161128_1049'),
    ]

    operations = [
        migrations.AddField(
            model_name='role',
            name='title_plural',
            field=models.CharField(max_length=255, blank=True, help_text=b"Optional plural version of title (if appending 's' isn't correct)"),
        ),
    ]
