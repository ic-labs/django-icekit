# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0004_auto_20161117_1201'),
    ]

    operations = [
        migrations.RenameField(
            model_name='author',
            old_name='introduction',
            new_name='oneliner',
        ),
    ]
