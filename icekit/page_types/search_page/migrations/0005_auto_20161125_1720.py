# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('search_page', '0004_auto_20161122_2121'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='searchpage',
            options={},
        ),
        migrations.AlterModelTable(
            name='searchpage',
            table='icekit_searchpage',
        ),
    ]
