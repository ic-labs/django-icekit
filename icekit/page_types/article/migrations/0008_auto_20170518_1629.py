# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_article', '0007_auto_20161130_1109'),
    ]

    operations = [
        migrations.AddField(
            model_name='article',
            name='admin_notes',
            field=models.TextField(help_text=b"Administrator's notes about this item", blank=True),
        ),
        migrations.AddField(
            model_name='article',
            name='brief',
            field=models.TextField(help_text=b'A document brief describing the purpose of this item', blank=True),
        ),
        migrations.AddField(
            model_name='articlecategorypage',
            name='admin_notes',
            field=models.TextField(help_text=b"Administrator's notes about this item", blank=True),
        ),
        migrations.AddField(
            model_name='articlecategorypage',
            name='brief',
            field=models.TextField(help_text=b'A document brief describing the purpose of this item', blank=True),
        ),
    ]
