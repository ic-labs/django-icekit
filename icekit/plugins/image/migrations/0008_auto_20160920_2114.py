# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0007_auto_20160920_1626'),
    ]

    operations = [
        migrations.AlterField(
            model_name='image',
            name='alt_text',
            field=models.CharField(help_text="A description of the image for users who don't see images. Leave blank if the image has no informational value.", max_length=255, blank=True),
        ),
        migrations.AlterField(
            model_name='image',
            name='title',
            field=models.CharField(help_text='Can be included in captions', max_length=255, blank=True),
        ),
    ]
