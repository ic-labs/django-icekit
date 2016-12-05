# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0007_auto_20161125_1720'),
    ]

    operations = [
        migrations.AlterField(
            model_name='author',
            name='portrait',
            field=models.ForeignKey(to='icekit_plugins_image.Image', blank=True, on_delete=django.db.models.deletion.SET_NULL, null=True),
        ),
        migrations.AlterField(
            model_name='authorlisting',
            name='hero_image',
            field=models.ForeignKey(related_name='+', help_text=b'The hero image for this content.', blank=True, to='icekit_plugins_image.Image', on_delete=django.db.models.deletion.SET_NULL, null=True),
        ),
    ]
