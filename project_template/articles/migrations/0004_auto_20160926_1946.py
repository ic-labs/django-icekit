# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_articles', '0003_auto_20160925_2320'),
    ]

    operations = [
        migrations.AlterField(
            model_name='article',
            name='parent',
            field=models.ForeignKey(default=1, to='glamkit_articles.ArticleCategoryPage'),
            preserve_default=False,
        ),
    ]
