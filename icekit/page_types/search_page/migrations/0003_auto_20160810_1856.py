# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('search_page', '0002_auto_20160420_0029'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='searchpage',
            options={'verbose_name': 'Search page'},
        ),
    ]
