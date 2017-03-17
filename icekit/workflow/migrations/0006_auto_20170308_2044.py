# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
from django.utils.timezone import utc
import datetime


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_workflow', '0005_auto_20170208_1146'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='workflowstate',
            options={'ordering': ('-datetime_modified',)},
        ),
        migrations.AddField(
            model_name='workflowstate',
            name='datetime_modified',
            field=models.DateTimeField(default=datetime.datetime(2017, 3, 8, 9, 44, 35, 18138, tzinfo=utc), auto_now=True),
            preserve_default=False,
        ),
    ]
