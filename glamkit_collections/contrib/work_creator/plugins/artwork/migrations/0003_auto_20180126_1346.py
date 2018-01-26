# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_artwork', '0002_remove_artwork_department'),
    ]

    operations = [
        migrations.AddField(
            model_name='artwork',
            name='is_on_display',
            field=models.BooleanField(help_text=b'Is the object on display within the gallery?', default=False),
        ),
        migrations.AlterField(
            model_name='artwork',
            name='dimensions_depth_cm',
            field=models.FloatField(null=True, verbose_name=b'depth (cm)', blank=True, help_text=b"The measurement of the object's depth, in centimetres"),
        ),
        migrations.AlterField(
            model_name='artwork',
            name='dimensions_display',
            field=models.CharField(blank=True, help_text=b'A display field that contains the dimensions of the object - the display height, width, and depth.', max_length=255),
        ),
        migrations.AlterField(
            model_name='artwork',
            name='dimensions_extent',
            field=models.CharField(verbose_name=b'extent', blank=True, help_text=b'A field to record the extent of the object represented by the dimensions in the object record, e.g., "image (w/o frame)," "overall (incl. pedestal)."', max_length=255),
        ),
        migrations.AlterField(
            model_name='artwork',
            name='dimensions_height_cm',
            field=models.FloatField(null=True, verbose_name=b'height (cm)', blank=True, help_text=b"The measurement of the object's height, in centimetres"),
        ),
        migrations.AlterField(
            model_name='artwork',
            name='dimensions_is_two_dimensional',
            field=models.BooleanField(help_text=b'A flag for rapid categorization of the object as essentially two-dimensional or three-dimensional. Used when generating the Preview scale drawing.', verbose_name=b'is two dimensional', default=False),
        ),
        migrations.AlterField(
            model_name='artwork',
            name='dimensions_weight_kg',
            field=models.FloatField(null=True, verbose_name=b'weight (kg)', blank=True, help_text=b"The measurement of the object's weight, in kilograms"),
        ),
        migrations.AlterField(
            model_name='artwork',
            name='dimensions_width_cm',
            field=models.FloatField(null=True, verbose_name=b'width (cm)', blank=True, help_text=b"The measurement of the object's width, in centimetres"),
        ),
    ]
