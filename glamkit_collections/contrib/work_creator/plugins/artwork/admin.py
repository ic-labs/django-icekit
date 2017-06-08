from django.contrib import admin
from glamkit_collections.contrib.work_creator.admin import WorkChildAdmin


class ArtworkAdmin(WorkChildAdmin):
    fieldsets = WorkChildAdmin.fieldsets[0:3] + (
        ('Medium', {
            'fields': (
                'medium_display',
            )
        }),
        ('Dimensions', {
            'fields': (
                'dimensions_is_two_dimensional',
                'dimensions_display',
                'dimensions_extent',
                'dimensions_width_cm',
                'dimensions_height_cm',
                'dimensions_depth_cm',
                'dimensions_weight_kg',
            )
        }),
    ) + WorkChildAdmin.fieldsets[3:]
