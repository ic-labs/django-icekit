from django.contrib import admin

from icekit.admin import ICEkitFluentContentsAdmin

from . import models


class LocationAdmin(ICEkitFluentContentsAdmin):
    prepopulated_fields = {"slug": ("title",)}

    fieldsets = (
            (None, {
                'fields': (
                    'title',
                    'slug',
                    'is_home_location',
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
        )


admin.site.register(models.Location, LocationAdmin)
