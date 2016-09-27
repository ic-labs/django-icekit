# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_articles', '0002_auto_20160923_1608'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='articlecategorypage',
            options={'verbose_name': 'Article category'},
        ),
    ]
