from django.contrib import admin
from django.conf import settings

from icekit.admin_tools.mixins import ThumbnailAdminMixin

from . import models

try:
    ADMIN_THUMB_ALIAS = settings.THUMBNAIL_ALIASES['']['admin']
except (AttributeError, KeyError):
    ADMIN_THUMB_ALIAS = {'size': (150, 150)}

class ImageAdmin(ThumbnailAdminMixin, admin.ModelAdmin):
    list_display = ['preview', 'title', 'alt_text',]
    list_display_links = ['alt_text', 'title', 'preview']
    filter_horizontal = ['categories', ]
    list_filter = ['categories',]
    search_fields = ['title', 'alt_text', 'caption', 'admin_notes', 'image']

    change_form_template = 'image/admin/change_form.html'

    # ThumbnailAdminMixin attributes
    thumbnail_field = 'image'
    thumbnail_options = ADMIN_THUMB_ALIAS

admin.site.register(models.Image, ImageAdmin)
