# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_quote', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='quoteitem',
            table='contentitem_icekit_plugins_quote_quoteitem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_quote' WHERE app_label='quote';"
        ),
    ]
