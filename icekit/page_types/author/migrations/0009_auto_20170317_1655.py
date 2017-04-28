# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import icekit.validators


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0020_auto_20170317_1655'),
        ('icekit_authors', '0008_auto_20161128_1049'),
    ]

    operations = [
        migrations.RenameField(
            model_name='author',
            old_name='portrait',
            new_name='hero_image',
        ),
        migrations.AlterField(
            model_name='author',
            name='url',
            field=models.CharField(help_text='The URL for the authors website.', max_length=255, verbose_name=b'URL', blank=True, validators=[icekit.validators.RelativeURLValidator()]),
        ),
    ]
