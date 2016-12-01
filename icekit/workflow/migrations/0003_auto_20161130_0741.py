# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('workflow', '0002_auto_20161128_1105'),
    ]

    operations = [
        migrations.AlterField(
            model_name='workflowstate',
            name='status',
            field=models.CharField(choices=[(b'new', b'New'), (b'ready_to_review', b'Ready to review'), (b'approved', b'Approved')], default=b'new', max_length=254),
        ),
    ]
