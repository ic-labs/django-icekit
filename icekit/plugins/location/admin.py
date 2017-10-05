from django.contrib import admin

from icekit.admin import ICEkitFluentContentsAdmin
from icekit.admin_tools.mixins import ListableMixinAdmin, HeroMixinAdmin, \
    GoogleMapMixinAdmin

from . import models


class AbstractLocationAdmin(
    ListableMixinAdmin,
    HeroMixinAdmin,
):
    prepopulated_fields = {"slug": ("title",)}

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
            ('Display details', {
                'fields': (
                    'address',
                    'phone_number',
                    'phone_number_call_to_action',
                    'url',
                    'url_call_to_action',
                    'email',
                    'email_call_to_action',
                )
            }),
        ) + \
        HeroMixinAdmin.FIELDSETS + \
        ListableMixinAdmin.FIELDSETS


class AbstractLocationWithGoogleMapAdmin(
    AbstractLocationAdmin
):

    fieldsets = AbstractLocationAdmin.fieldsets + \
        GoogleMapMixinAdmin.FIELDSETS


class LocationAdmin(
    AbstractLocationWithGoogleMapAdmin,
    ICEkitFluentContentsAdmin,
):
    list_filter = ICEkitFluentContentsAdmin.list_filter


admin.site.register(models.Location, LocationAdmin)
