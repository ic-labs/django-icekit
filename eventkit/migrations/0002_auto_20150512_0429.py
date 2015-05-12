# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('eventkit', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='repeat_expression',
            field=models.TextField(help_text=b'An RFC2445 expression that defines when this event repeats.', max_length=255, null=True),
        ),
    ]
