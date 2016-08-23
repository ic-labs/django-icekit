# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_page_anchor', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='pageanchoritem',
            table='contentitem_icekit_plugins_page_anchor_pageanchoritem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_page_anchor' WHERE app_label='page_anchor';"
        ),
    ]
