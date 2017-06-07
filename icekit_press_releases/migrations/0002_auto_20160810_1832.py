# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_press_releases', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='pressreleasecategory',
            options={'verbose_name_plural': 'press release categories'},
        ),
        migrations.AlterField(
            model_name='presscontact',
            name='email',
            field=models.EmailField(max_length=255, blank=True),
        ),
        migrations.AlterField(
            model_name='presscontact',
            name='phone',
            field=models.CharField(max_length=255, blank=True),
        ),
        migrations.AlterField(
            model_name='presscontact',
            name='title',
            field=models.CharField(max_length=255, blank=True),
        ),
    ]
