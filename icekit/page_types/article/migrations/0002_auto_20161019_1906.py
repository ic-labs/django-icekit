# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_article', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='articlecategorypage',
            options={'verbose_name': 'Article category page'},
        ),
    ]
