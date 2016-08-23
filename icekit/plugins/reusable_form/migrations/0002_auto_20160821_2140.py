# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_reusable_form', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='formitem',
            table='contentitem_icekit_plugins_reusable_form_formitem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_reusable_form' WHERE app_label='reusable_form';"
        ),
    ]

