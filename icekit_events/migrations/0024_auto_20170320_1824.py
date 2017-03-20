# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0023_auto_20170320_1820'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventbase',
            name='external_ref',
            field=models.CharField(verbose_name=b'External reference', max_length=255, help_text=b'The reference identifier used by an external events/tickets management system.', blank=True, null=True),
        ),
    ]
