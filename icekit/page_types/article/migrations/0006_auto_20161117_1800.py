# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_article', '0005_add_hero'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='articlecategorypage',
            options={},
        ),
        migrations.AlterModelTable(
            name='articlecategorypage',
            table='icekit_articlecategorypage',
        ),
    ]
