# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_articles', '0005_auto_20160926_2023'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='article',
            unique_together=set([('slug', 'publishing_is_draft', 'parent')]),
        ),
    ]
