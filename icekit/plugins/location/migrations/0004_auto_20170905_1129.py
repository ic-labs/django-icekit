# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_location', '0003_locationitem'),
    ]

    operations = [
        migrations.AlterField(
            model_name='location',
            name='email_call_to_action',
            field=models.CharField(max_length=255, default=b'Email', blank=True, help_text=b"\n            Call to action text to show next to the location's email address.\n        "),
        ),
    ]
