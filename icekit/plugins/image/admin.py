from django.contrib import admin
from django.conf import settings

from icekit.utils.admin.mixins import ThumbnailAdminMixin

from . import models


class ImageAdmin(ThumbnailAdminMixin, admin.ModelAdmin):
    list_display = ['thumbnail', 'title', 'alt_text',]
    list_display_links = ['alt_text', 'thumbnail']
    filter_horizontal = ['categories', ]
    list_filter = ['categories',]
    search_fields = ['title', 'alt_text', 'caption', 'admin_notes', 'image']

    change_form_template = 'image/admin/change_form.html'

    # ThumbnailAdminMixin attributes
    thumbnail_field = 'image'
    thumbnail_options = settings.THUMBNAIL_ALIASES['']['admin']

admin.site.register(models.Image, ImageAdmin)
