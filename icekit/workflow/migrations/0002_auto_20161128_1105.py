# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
from django.conf import settings
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_workflow', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='workflowstate',
            name='assigned_to',
            field=models.ForeignKey(to=settings.AUTH_USER_MODEL, blank=True, on_delete=django.db.models.deletion.SET_NULL, null=True, help_text=b'User responsible for item at this stage in the workflow'),
        ),
    ]
