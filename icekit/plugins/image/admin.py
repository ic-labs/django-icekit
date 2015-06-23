from django.contrib import admin

from . import models


class ImageAdmin(admin.ModelAdmin):
    filter_horizontal = ['categories', ]
    list_filter = ['categories', 'is_active', ]


admin.site.register(models.Image, ImageAdmin)
