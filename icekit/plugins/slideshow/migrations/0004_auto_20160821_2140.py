# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_slideshow', '0003_auto_20160404_0118'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='slideshow',
            table=None,
        ),
        migrations.AlterModelTable(
            name='slideshowitem',
            table='contentitem_icekit_plugins_slideshow_slideshowitem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_slideshow' WHERE app_label='slideshow';"
        ),
    ]
