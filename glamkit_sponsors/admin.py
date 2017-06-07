"""
Administration configuration for Sponser models.
"""
from django.contrib import admin
from icekit.admin_tools.mixins import ThumbnailAdminMixin

from . import models


class SponsorAdmin(admin.ModelAdmin, ThumbnailAdminMixin):
    """
    Administration configuration for the `Sponsor` model.
    """
    list_display = ('name', 'thumbnail', 'url')
    list_display_links = ("name", "thumbnail")
    raw_id_fields = ['logo', ]

    def get_thumbnail_source(self, obj):
        return obj.logo.image

# Administration registration.
admin.site.register(models.Sponsor, SponsorAdmin)
