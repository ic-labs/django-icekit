# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0002_auto_20160831_1831'),
    ]

    operations = [
        migrations.RenameField(
            model_name='author',
            old_name='last_name',
            new_name='family_name',
        ),
        migrations.RenameField(
            model_name='author',
            old_name='first_name',
            new_name='given_name',
        ),
    ]
