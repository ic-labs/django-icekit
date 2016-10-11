# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='author',
            options={'ordering': ('family_name', 'given_names')},
        ),
        migrations.RenameField(
            model_name='author',
            old_name='given_name',
            new_name='given_names',
        ),
    ]
