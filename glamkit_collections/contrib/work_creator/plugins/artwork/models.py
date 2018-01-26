from glamkit_collections.contrib.work_creator.models import WorkBase
from django.db import models


class Artwork(WorkBase):
    medium_display = models.CharField(
        blank=True,
        max_length=255,
        help_text='A display field for information concerning the '
                  'material/media & support of the object'
    )
    category = models.ForeignKey(
        'gk_collections_work_creator.WorkCategory',
        blank=True,
        null=True,
        related_name='artworks',
        help_text='A broad category that the work belongs to, e.g., "Painting", "Sculpture"'
    )

    # how big is it
    dimensions_is_two_dimensional = models.BooleanField(
        'is two dimensional',
        blank=True,
        default=False,
        help_text="A flag for rapid categorization of the object as "
                  "essentially two-dimensional or three-dimensional. "
                  "Used when generating the Preview scale drawing."
    )
    dimensions_display = models.CharField(
        blank=True,
        max_length=255,
        help_text='A display field that contains the dimensions of the object '
                  '- the display height, width, and depth.'
    )
    dimensions_extent = models.CharField(
        'extent',
        blank=True,
        max_length=255,
        help_text='A field to record the extent of the object represented by '
                  'the dimensions in the object record, '
                  'e.g., "image (w/o frame)," "overall (incl. pedestal)."'
    )
    dimensions_width_cm = models.FloatField(
        'width (cm)',
        blank=True,
        null=True,
        help_text='The measurement of the object\'s width, in centimetres'
    )
    dimensions_height_cm = models.FloatField(
        'height (cm)',
        blank=True,
        null=True,
        help_text='The measurement of the object\'s height, in centimetres'
    )
    dimensions_depth_cm = models.FloatField(
        'depth (cm)',
        blank=True,
        null=True,
        help_text='The measurement of the object\'s depth, in centimetres'
    )
    dimensions_weight_kg = models.FloatField(
        'weight (kg)',
        blank=True,
        null=True,
        help_text="The measurement of the object\'s weight, in kilograms"
    )
    is_on_display = models.BooleanField(default=False, help_text='Is the object on display within the gallery?')
