# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0003_auto_20150623_0115'),
    ]

    operations = [
        migrations.AlterField(
            model_name='image',
            name='alt_text',
            field=models.CharField(help_text="A description of the image for users who don't see images", max_length=255),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='image',
            name='title',
            field=models.CharField(help_text='The title is shown in the "title" attribute', max_length=255, blank=True),
            preserve_default=True,
        ),
    ]
