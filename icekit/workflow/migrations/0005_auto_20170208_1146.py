# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_workflow', '0004_auto_20170130_1146'),
    ]

    operations = [
        migrations.AlterField(
            model_name='workflowstate',
            name='assigned_to',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL, help_text=b'User who is responsible for this content at this stage in the workflow', blank=True),
        ),
    ]
