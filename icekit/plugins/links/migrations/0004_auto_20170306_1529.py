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
            field=models.CharField(verbose_name=b'Link style', choices=[(b'', b'Normal')], blank=True, max_length=255),
        ),
        migrations.AlterField(
            model_name='authorlink',
            name='style',
            field=models.CharField(verbose_name=b'Link style', choices=[(b'', b'Normal')], blank=True, max_length=255),
        ),
        migrations.AlterField(
            model_name='pagelink',
            name='style',
            field=models.CharField(verbose_name=b'Link style', choices=[(b'', b'Normal')], blank=True, max_length=255),
        ),
    ]
