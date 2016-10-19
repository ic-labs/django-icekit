# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('eventlistingfordate', '0002_auto_20161018_1113'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='eventlistingpage',
            options={'verbose_name': 'Event listing for date'},
        ),
    ]
