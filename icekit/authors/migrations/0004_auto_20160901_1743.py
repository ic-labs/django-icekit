# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0003_auto_20160901_1536'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='author',
            options={'ordering': ('family_name',)},
        ),
        migrations.AlterField(
            model_name='author',
            name='slug',
            field=models.SlugField(),
        ),
    ]
