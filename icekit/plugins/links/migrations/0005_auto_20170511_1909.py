# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
from .. import appsettings

class Migration(migrations.Migration):

    dependencies = [
        ('ik_links', '0004_auto_20170314_1401'),
        ('ik_links', '0004_auto_20170306_1529'),
    ]

    operations = [
        migrations.AlterField(
            model_name='articlelink',
            name='style',
            field=models.CharField(choices=appsettings.RELATION_STYLE_CHOICES, max_length=255, verbose_name=b'Link style', blank=True),
        ),
        migrations.AlterField(
            model_name='authorlink',
            name='style',
            field=models.CharField(choices=appsettings.RELATION_STYLE_CHOICES, max_length=255, verbose_name=b'Link style', blank=True),
        ),
        migrations.AlterField(
            model_name='pagelink',
            name='style',
            field=models.CharField(choices=appsettings.RELATION_STYLE_CHOICES, max_length=255, verbose_name=b'Link style', blank=True),
        ),
    ]
