# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_articles', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='article',
            name='slug',
            field=models.SlugField(max_length=255, default='woo'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='article',
            name='title',
            field=models.CharField(max_length=255, default='woo'),
            preserve_default=False,
        ),
    ]
