"""
Administration configuration for Sponser models.
"""
from django.contrib import admin
from help_me.admin_mixins import HelpMyFormMixin
from icekit.utils.admin.mixins import ThumbnailAdminMixin

from . import models


class SponsorAdmin(HelpMyFormMixin, ThumbnailAdminMixin):
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
