# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_articles', '0003_auto_20161012_2256'),
    ]

    operations = [
        migrations.AlterField(
            model_name='article',
            name='parent',
            field=models.ForeignKey(to='glamkit_articles.ArticleCategoryPage', on_delete=django.db.models.deletion.PROTECT),
        ),
    ]
