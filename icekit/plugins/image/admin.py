from django.contrib import admin

from icekit.utils.admin.mixins import ThumbnailAdminMixin

from . import models


class ImageAdmin(ThumbnailAdminMixin, admin.ModelAdmin):
    list_display = ['thumbnail', 'alt_text', 'title', ]
    list_display_links = ['alt_text', 'thumbnail']
    filter_horizontal = ['categories', ]
    list_filter = ['categories', 'is_active', ]
    search_fields = ['title', 'alt_text', 'caption', 'admin_notes', ]
    # ThumbnailAdminMixin attributes
    thumbnail_field = 'image'
    thumbnail_options = {
        'size': (150, 150),
    }
    thumbnail_show_exceptions = True

admin.site.register(models.Image, ImageAdmin)
