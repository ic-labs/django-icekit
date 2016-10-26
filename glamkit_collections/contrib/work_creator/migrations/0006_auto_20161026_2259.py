# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0005_workbase_images'),
    ]

    operations = [
        migrations.AddField(
            model_name='workbase',
            name='one_liner',
            field=models.CharField(blank=True, help_text=b'A pithy description of the work', max_length=511, verbose_name=b'One-liner'),
        ),
        migrations.AddField(
            model_name='workbase',
            name='subtitle',
            field=models.CharField(blank=True, max_length=511),
        ),
    ]
