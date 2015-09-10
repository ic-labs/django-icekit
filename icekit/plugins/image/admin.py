from django.contrib import admin

from icekit.utils.admin.mixins import ThumbnailAdminMixin

from . import models


class ImageAdmin(ThumbnailAdminMixin, admin.ModelAdmin):
    list_display = ['description', 'title', 'thumbnail']
    list_display_links = ['description', 'thumbnail']
    filter_horizontal = ['categories', ]
    list_filter = ['categories', 'is_active', ]
    # ThumbnailAdminMixin attributes
    thumbnail_field = 'image'
    thumbnail_options = {
        'size': (150, 150),
    }

    def title(self, image):
        return image.title

    def description(self, image):
        return unicode(image)

admin.site.register(models.Image, ImageAdmin)
