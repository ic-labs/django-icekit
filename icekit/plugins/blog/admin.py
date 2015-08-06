from django.contrib import admin

from . import models


class PostAdmin(admin.ModelAdmin):
    list_filter = ['category', 'is_active', ]


admin.site.register(models.Post, PostAdmin)
admin.site.register(models.ContentCategory)
admin.site.register(models.Location)
