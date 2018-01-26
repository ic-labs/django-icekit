from django.contrib import admin
from glamkit_collections.contrib.work_creator.admin import WorkChildAdmin


class ArtworkAdmin(WorkChildAdmin):
    fieldsets = WorkChildAdmin.fieldsets[0:2] + (
        ('Details', {
            'fields': (
                'credit_line',
                'accession_number',
                'is_on_display',
                'category',
                'department',
                'list_image',
                'boosted_search_terms',
                'admin_notes',
            ),
        }),
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

    raw_id_fields = WorkChildAdmin.raw_id_fields + ('category',)
