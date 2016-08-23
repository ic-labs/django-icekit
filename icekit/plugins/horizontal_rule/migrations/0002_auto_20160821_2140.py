# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_horizontal_rule', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='horizontalruleitem',
            table='contentitem_icekit_plugins_horizontal_rule_horizontalruleitem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_horizontal_rule' WHERE app_label='horizontal_rule';"
        ),
    ]
