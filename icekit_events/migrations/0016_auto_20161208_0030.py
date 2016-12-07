# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0015_auto_20161208_0029'),
    ]

    operations = [
        migrations.AlterField(
            model_name='occurrence',
            name='is_protected_from_regeneration',
            field=models.BooleanField(db_index=True, default=False, verbose_name=b'is protected', help_text=b"if this is true, the occurrence won't be deleted when occurrences are regenerated"),
        ),
    ]
