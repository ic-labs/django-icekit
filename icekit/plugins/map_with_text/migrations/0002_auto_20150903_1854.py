# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('map_with_text', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='mapwithtextitem',
            name='share_url_new',
            field=models.URLField(default=0, help_text=b'Share URL sourced from Google Maps. See https://support.google.com/maps/answer/144361?hl=en', max_length=500, verbose_name=b'Share URL'),
            preserve_default=False,
        ),
    ]
