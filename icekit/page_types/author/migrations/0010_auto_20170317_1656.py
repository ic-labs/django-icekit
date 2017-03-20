# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0009_auto_20170317_1655'),
    ]

    operations = [
        migrations.AlterField(
            model_name='author',
            name='hero_image',
            field=models.ForeignKey(blank=True, help_text=b'The hero image for this content.', null=True, on_delete=django.db.models.deletion.SET_NULL, to='icekit_plugins_image.Image', related_name='+'),
        ),
    ]
