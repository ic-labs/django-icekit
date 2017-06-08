import models
from django.contrib import admin
from ..moving_image.admin import MovingImageWorkAdmin
from icekit.content_collections.admin import TitleSlugAdmin

class FilmAdmin(MovingImageWorkAdmin):
    fieldsets = MovingImageWorkAdmin.fieldsets[0:3] + (
        ('Film', {
            'fields': (
                'formats',
            )
        }),
    ) + MovingImageWorkAdmin.fieldsets[3:]
    filter_horizontal = ('formats',)

admin.site.register(models.Format, TitleSlugAdmin)
