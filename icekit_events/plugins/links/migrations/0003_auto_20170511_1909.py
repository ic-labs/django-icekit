# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
from icekit.plugins.links import appsettings


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events_links', '0002_auto_20170314_1401'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventlink',
            name='style',
            field=models.CharField(choices=appsettings.RELATION_STYLE_CHOICES, max_length=255, verbose_name=b'Link style', blank=True),
        ),
    ]
