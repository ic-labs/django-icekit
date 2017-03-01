# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_content_listing', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='contentlistingitem',
            name='limit',
            field=models.IntegerField(help_text=b'How many items to show? No limit is applied if this field is not set', blank=True, null=True),
        ),
    ]
