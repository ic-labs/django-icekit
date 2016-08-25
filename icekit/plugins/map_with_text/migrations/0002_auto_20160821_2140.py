# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_map_with_text', '0001_squashed_0003_mapwithtextitem'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='mapwithtextitem',
            table='contentitem_icekit_plugins_map_with_text_mapwithtextitem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_map_with_text' WHERE app_label='map_with_text';"
        ),
    ]
