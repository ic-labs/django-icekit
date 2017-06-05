# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_contact_person', '0002_auto_20161110_1531'),
    ]

    operations = [
        migrations.AddField(
            model_name='contactperson',
            name='phone_display',
            field=models.CharField(max_length=255, help_text=b"The phone number to display, if different from above, e.g. '0123 456-789'", verbose_name=b'Phone number to display', blank=True),
        ),
        migrations.RenameField(
            model_name='contactperson',
            old_name='phone',
            new_name='phone_full',
        ),
        migrations.AlterField(
            model_name='contactperson',
            name='phone_full',
            field=models.CharField(verbose_name=b'Phone number', blank=True,
                                   help_text=b"The full (international) phone number to dial, including the country code, e.g. '+61 123456789'",
                                   max_length=255),
        ),
    ]
