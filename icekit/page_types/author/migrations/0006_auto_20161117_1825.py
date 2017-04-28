# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0005_auto_20161117_1824'),
    ]

    operations = [
        migrations.AlterField(
            model_name='author',
            name='oneliner',
            field=models.CharField(max_length=255, help_text='An introduction about the author used on list pages.', blank=True),
        ),
    ]
