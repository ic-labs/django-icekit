# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0014_image_external_ref'),
    ]

    operations = [
        migrations.RenameField(
            model_name='image',
            old_name='maximum_dimension',
            new_name='maximum_dimension_pixels',
        ),
        migrations.AlterField(
            model_name='image',
            name='maximum_dimension_pixels',
            field=models.PositiveIntegerField(blank=True, help_text='If this image is to be limited to a particular pixel size for distribution, note it here.', null=True),
        ),
        migrations.AlterField(
            model_name='image',
            name='alt_text',
            field=models.CharField(max_length=255, blank=True, help_text="A description of the image for users who don't see images visually. Leave blank if the image has no informational value."),
        ),
    ]
