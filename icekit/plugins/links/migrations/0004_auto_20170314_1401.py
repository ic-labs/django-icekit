# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ik_links', '0003_auto_20161117_1810'),
    ]

    operations = [
        migrations.AlterField(
            model_name='articlelink',
            name='style',
            field=models.CharField(choices=[(b'', b'Normal')], max_length=255, verbose_name=b'Link style', blank=True),
        ),
        migrations.AlterField(
            model_name='authorlink',
            name='style',
            field=models.CharField(choices=[(b'', b'Normal')], max_length=255, verbose_name=b'Link style', blank=True),
        ),
        migrations.AlterField(
            model_name='pagelink',
            name='style',
            field=models.CharField(choices=[(b'', b'Normal')], max_length=255, verbose_name=b'Link style', blank=True),
        ),
    ]
