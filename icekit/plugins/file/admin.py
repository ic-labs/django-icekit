from django.contrib import admin

from . import models


class FileAdmin(admin.ModelAdmin):
    filter_horizontal = ['categories', ]
    list_display = ['__str__', 'extension', 'file_size', 'is_active', ]
    list_filter = ['categories', 'is_active', ]
    search_fields = ['title', 'file', 'admin_notes', ]


admin.site.register(models.File, FileAdmin)
