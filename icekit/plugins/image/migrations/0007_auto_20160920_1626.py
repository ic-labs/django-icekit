# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0006_auto_20160309_0453'),
    ]

    operations = [
        migrations.AddField(
            model_name='imageitem',
            name='show_caption',
            field=models.BooleanField(default=True),
        ),
        migrations.AddField(
            model_name='imageitem',
            name='show_title',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='imageitem',
            name='title_override',
            field=models.CharField(max_length=512, blank=True),
        ),
        migrations.AlterField(
            model_name='image',
            name='alt_text',
            field=models.CharField(help_text="A description of the image for users who don't see images", max_length=255, blank=True),
        ),
    ]
