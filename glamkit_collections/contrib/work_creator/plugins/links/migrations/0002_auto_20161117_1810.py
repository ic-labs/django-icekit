# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_links', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='creatorlink',
            name='oneliner_override',
            field=models.CharField(blank=True, max_length=255),
        ),
        migrations.AddField(
            model_name='worklink',
            name='oneliner_override',
            field=models.CharField(blank=True, max_length=255),
        ),
    ]
