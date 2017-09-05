# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_location', '0004_auto_20170905_1129'),
    ]

    operations = [
        migrations.AddField(
            model_name='location',
            name='phone_number_call_to_action',
            field=models.CharField(blank=True, help_text=b"\n            Call to action text to show for the location's phone number.\n        ", max_length=255, default=b'Phone'),
        ),
        migrations.AddField(
            model_name='location',
            name='url_call_to_action',
            field=models.CharField(blank=True, help_text=b"\n            Call to action text to show for the location's url.\n        ", max_length=255, default=b'Website'),
        ),
        migrations.AlterField(
            model_name='location',
            name='email_call_to_action',
            field=models.CharField(blank=True, help_text=b"\n            Call to action text to show for the location's email address.\n        ", max_length=255, default=b'Email'),
        ),
    ]
