import models
from django.contrib import admin
from glamkit_collections.contrib.work_creator.admin import WorkChildAdmin
from icekit.content_collections.admin import TitleSlugAdmin


class MovingImageWorkAdmin(WorkChildAdmin):
    fieldsets = WorkChildAdmin.fieldsets[0:3] + (
        ('Moving image', {
            'fields': (
                'genres',
                'language',
                'media_type',
                'duration_minutes',
                'rating',
                'rating_annotation',
                'trailer',
                'imdb_link',
            )
        }),
    ) + WorkChildAdmin.fieldsets[3:]

admin.site.register(models.Genre, TitleSlugAdmin)
admin.site.register(models.Rating, TitleSlugAdmin)
admin.site.register(models.MediaType, TitleSlugAdmin)


