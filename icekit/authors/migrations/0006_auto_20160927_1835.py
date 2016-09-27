# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0005_authorlisting'),
    ]

    operations = [
        migrations.AddField(
            model_name='author',
            name='title',
            field=models.CharField(max_length=255, default='Untitled'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='author',
            name='slug',
            field=models.SlugField(max_length=255),
        ),
    ]
