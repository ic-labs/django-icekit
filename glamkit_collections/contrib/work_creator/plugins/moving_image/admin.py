import models
from django.contrib import admin
from glamkit_collections.contrib.work_creator.admin import WorkChildAdmin
from icekit.content_collections.admin import TitleSlugAdmin


class MovingImageWorkAdmin(WorkChildAdmin):
    MOVING_IMAGE_FIELDSETS = (
        ('Moving image', {
            'fields': (
                'genre',
                'media_type',
                'duration_minutes',
                'rating',
                'rating_annotation',
                'trailer',
                'imdb_link',
            )
        }),
    )
    fieldsets = WorkChildAdmin.fieldsets[0:3] + MOVING_IMAGE_FIELDSETS + WorkChildAdmin.fieldsets[3:]

admin.site.register(models.Genre, TitleSlugAdmin)
admin.site.register(models.Rating, TitleSlugAdmin)
admin.site.register(models.MediaType, TitleSlugAdmin)


