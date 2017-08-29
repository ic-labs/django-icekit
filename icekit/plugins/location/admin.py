from django.contrib import admin

from icekit.admin import ICEkitFluentContentsAdmin
from icekit.admin_tools.mixins import ListableMixinAdmin, HeroMixinAdmin

from . import models


class LocationAdmin(
    ICEkitFluentContentsAdmin,
    ListableMixinAdmin,
    HeroMixinAdmin,
):
    prepopulated_fields = {"slug": ("title",)}
    list_filter = ICEkitFluentContentsAdmin.list_filter

    raw_id_fields = HeroMixinAdmin.raw_id_fields

    fieldsets = (
            (None, {
                'fields': (
                    'title',
                    'slug',
                    'is_home_location',
                    'layout',
                )
            }),
            ('Map', {
                'fields': (
                    'map_description',
                    'map_center',
                    'map_zoom',
                    'map_marker',
                    'map_embed_code',
                )
            }),
            ('Display details', {
                'fields': (
                    'address',
                    'phone_number',
                    'url',
                    'email',
                    'email_call_to_action',
                )
            }),
        ) + \
        HeroMixinAdmin.FIELDSETS + \
        ListableMixinAdmin.FIELDSETS


admin.site.register(models.Location, LocationAdmin)
