# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0021_merge'),
    ]

    operations = [
        migrations.AddField(
            model_name='imageitem',
            name='carousel_cta_text_label',
            field=models.CharField(max_length=255, verbose_name=b'Carousel CTA Text Label', blank=True),
        ),
        migrations.AddField(
            model_name='imageitem',
            name='carousel_cta_url',
            field=icekit.fields.ICEkitURLField(max_length=300, null=True, verbose_name=b'Carousel CTA URL', blank=True),
        ),
    ]
