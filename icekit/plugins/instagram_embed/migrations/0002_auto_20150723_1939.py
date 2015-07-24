# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('instagram_embed', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='instagramembeditem',
            name='url',
            field=models.URLField(verbose_name='URL'),
            preserve_default=True,
        ),
    ]
