# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models

def make_repurpose_configs(apps, schema_editor):
    Config = apps.get_model("icekit_plugins_image", "ImageRepurposeConfig")

    Config.objects.get_or_create(
        title = "Original",
        defaults = {
            'format': 'jpg',
            'style': 'default',
        }
    )
    Config.objects.get_or_create(
        title = "Presentation",
        defaults = {
            'width': 1280,
            'height': 1024,
            'format': 'jpg',
            'style': 'default',
        }
    )
    Config.objects.get_or_create(
        title = "Facebook",
        defaults = {
            'width': 1200,
            'format': 'jpg',
            'style': 'default',
        }
    )
    Config.objects.get_or_create(
        title = "Twitter",
        defaults = {
            'width': 440,
            'height': 220,
            'is_cropping_allowed': True,
            'format': 'jpg',
            'style': 'default',
        }
    )
    Config.objects.get_or_create(
        title = "Instagram",
        defaults = {
            'width': 1080,
            'height': 1080,
            'is_cropping_allowed': True,
            'format': 'jpg',
            'style': 'default',
        }
    )
    Config.objects.get_or_create(
        title = "YouTube",
        defaults = {
            'width': 1280,
            'height': 760,
            'is_cropping_allowed': True,
            'format': 'jpg',
            'style': 'default',
        }
    )


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0015_auto_20170310_2004'),
    ]

    operations = [
        migrations.RunPython(make_repurpose_configs)
    ]
