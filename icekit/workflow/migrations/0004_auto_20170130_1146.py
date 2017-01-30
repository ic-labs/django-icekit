# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_workflow', '0003_auto_20161130_0741'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='workflowstate',
            table=None,
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_workflow' WHERE app_label='workflow';"
        ),
    ]
