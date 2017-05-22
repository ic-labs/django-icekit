# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('layout_page', '0007_auto_20170509_1148'),
    ]

    operations = [
        migrations.AddField(
            model_name='layoutpage',
            name='admin_notes',
            field=models.TextField(help_text=b"Administrator's notes about this content", blank=True),
        ),
        migrations.AddField(
            model_name='layoutpage',
            name='brief',
            field=models.TextField(help_text=b'A document brief describing the purpose of this content', blank=True),
        ),
    ]
