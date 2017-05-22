# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('search_page', '0006_searchpage_default_search_type'),
    ]

    operations = [
        migrations.AddField(
            model_name='searchpage',
            name='admin_notes',
            field=models.TextField(help_text=b"Administrator's notes about this content", blank=True),
        ),
        migrations.AddField(
            model_name='searchpage',
            name='brief',
            field=models.TextField(help_text=b'A document brief describing the purpose of this content', blank=True),
        ),
    ]
