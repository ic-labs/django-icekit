# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0011_auto_20161128_1049'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventtype',
            name='title_plural',
            field=models.CharField(help_text=b"Optional plural version of title (if appending 's' isn't correct)", max_length=255, blank=True),
        ),
    ]
