import models
from django.contrib import admin
from glamkit_collections.contrib.work_creator.work_types.moving_image.admin import \
    MovingImageWorkAdmin
from icekit.content_collections.admin import TitleSlugAdmin

class FilmAdmin(MovingImageWorkAdmin):
    FILM_MIXIN_FIELDSETS = (
        ('Film', {
            'fields': (
                'formats',
            )
        }),
    )

    fieldsets = MovingImageWorkAdmin.fieldsets[0:3] + FILM_MIXIN_FIELDSETS + MovingImageWorkAdmin.fieldsets[3:]
    filter_horizontal = ('formats',)

admin.site.register(models.FilmFormat, TitleSlugAdmin)
