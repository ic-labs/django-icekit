# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_oembed_with_caption', '0007_auto_20161110_1513'),
    ]

    operations = [
        migrations.AddField(
            model_name='oembedwithcaptionitem',
            name='content_title',
            field=models.CharField(blank=True, verbose_name=b'title', max_length=1000),
        ),
    ]
