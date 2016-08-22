# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_map', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='mapitem',
            table='contentitem_icekit_plugins_map_mapitem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_map' WHERE app_label='reusable_map';"
        ),
    ]
