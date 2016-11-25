# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0006_auto_20161117_1825'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='authorlisting',
            options={},
        ),
        migrations.AlterModelTable(
            name='authorlisting',
            table='icekit_authorlisting',
        ),
    ]
