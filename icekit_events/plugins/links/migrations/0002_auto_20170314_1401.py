# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events_links', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventlink',
            name='style',
            field=models.CharField(choices=[(b'', b'Normal')], max_length=255, verbose_name=b'Link style', blank=True),
        ),
    ]
