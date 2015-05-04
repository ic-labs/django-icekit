from django.contrib import admin

from . import models


class ImageAdmin(admin.ModelAdmin):
    filter_horizontal = ['categories', ]


admin.site.register(models.Image, ImageAdmin)
