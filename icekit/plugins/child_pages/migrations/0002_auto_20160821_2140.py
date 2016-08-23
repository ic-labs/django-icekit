# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_child_pages', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='childpageitem',
            table='contentitem_icekit_plugins_child_pages_childpageitem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_child_pages' WHERE app_label='child_pages';"
        ),
    ]
