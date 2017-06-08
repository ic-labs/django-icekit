# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0022_auto_20170320_1807'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventrepeatsgenerator',
            name='end',
            field=models.DateTimeField(db_index=True, verbose_name=b'first end'),
        ),
        migrations.AlterField(
            model_name='eventrepeatsgenerator',
            name='start',
            field=models.DateTimeField(db_index=True, verbose_name=b'first start'),
        ),
    ]
