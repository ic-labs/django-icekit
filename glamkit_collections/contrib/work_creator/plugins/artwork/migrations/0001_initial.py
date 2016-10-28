# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Artwork',
            fields=[
                ('workbase_ptr', models.OneToOneField(serialize=False, to='gk_collections_work_creator.WorkBase', auto_created=True, primary_key=True, parent_link=True)),
                ('medium_display', models.CharField(max_length=255, blank=True, help_text=b'A display field for information concerning the material/media & support of the object')),
                ('dimensions_is_two_dimensional', models.BooleanField(default=False, help_text=b'A flag for rapid categorization of the object as essentially two-dimensional or three-dimensional. Used when generating the Preview scale drawing.')),
                ('dimensions_display', models.CharField(max_length=255, blank=True, help_text=b'A display field that contains the dimensions of the object - the Display Height, Width, and Depth.')),
                ('dimensions_extent', models.CharField(max_length=255, blank=True, help_text=b'A field to record the extent of the object represented by the dimensions in the object record, e.g., "image (w/o frame)," "overall (incl. pedestal)."')),
                ('dimensions_width_cm', models.FloatField(blank=True, null=True, help_text=b"The measurement of the object's width, in metres")),
                ('dimensions_height_cm', models.FloatField(blank=True, null=True, help_text=b'ditto height')),
                ('dimensions_depth_cm', models.FloatField(blank=True, null=True, help_text=b'ditto depth')),
                ('dimensions_weight_kg', models.FloatField(blank=True, null=True, help_text=b"The measurement of the object's width, in kilograms")),
                ('department', models.CharField(max_length=255, blank=True, help_text=b'The managerial unit responsible for the object, e.g., "Western Painting."')),
            ],
            options={
                'abstract': False,
            },
            bases=('gk_collections_work_creator.workbase',),
        ),
    ]
