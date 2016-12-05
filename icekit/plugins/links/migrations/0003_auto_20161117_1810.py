# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ik_links', '0002_auto_20161117_1221'),
    ]

    operations = [
        migrations.AddField(
            model_name='articlelink',
            name='oneliner_override',
            field=models.CharField(blank=True, max_length=255),
        ),
        migrations.AddField(
            model_name='authorlink',
            name='oneliner_override',
            field=models.CharField(blank=True, max_length=255),
        ),
        migrations.AddField(
            model_name='pagelink',
            name='oneliner_override',
            field=models.CharField(blank=True, max_length=255),
        ),
    ]
