from glamkit_collections.contrib.work_creator.models import WorkBase
from django.db import models

class Artwork(WorkBase):
    medium_display = models.CharField(
        blank=True,
        max_length=255,
        help_text='A display field for information concerning the '
                  'material/media & support of the object'
    )

    # how big is it
    dimensions_is_two_dimensional = models.BooleanField(
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
                  '- the Display Height, Width, and Depth.'
    )
    dimensions_extent = models.CharField(
        blank=True,
        max_length=255,
        help_text='A field to record the extent of the object represented by '
                  'the dimensions in the object record, '
                  'e.g., "image (w/o frame)," "overall (incl. pedestal)."'
    )
    dimensions_width_cm = models.FloatField(
        blank=True,
        null=True,
        help_text='The measurement of the object\'s width, in metres'
    )
    dimensions_height_cm = models.FloatField(
        blank=True,
        null=True, help_text="ditto height"
    )
    dimensions_depth_cm = models.FloatField(
        blank=True,
        null=True, help_text="ditto depth"
    )
    dimensions_weight_kg = models.FloatField(
        blank=True,
        null=True,
        help_text="The measurement of the object\'s width, in kilograms"
    )