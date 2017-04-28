from django.contrib import admin
from icekit.admin import ICEkitFluentContentsAdmin
from icekit.admin_tools.mixins import HeroMixinAdmin, ListableMixinAdmin

from . import models


class AuthorAdmin(
    ICEkitFluentContentsAdmin,
    HeroMixinAdmin,
    ListableMixinAdmin,
):
    """
    Administration configuration for `Author`.
    """
    change_form_template = 'icekit_authors/admin/change_form.html'
    search_fields = ['slug', 'given_names', 'family_name']
    list_display = ICEkitFluentContentsAdmin.list_display + \
        ('given_names', 'family_name')
    prepopulated_fields = {"slug": ("given_names", "family_name")}
    ordering = ("family_name", "given_names",)

    fieldsets = (
            (None, {
                'fields': (
                    'given_names',
                    'family_name',
                    'slug',
                    'url',
                    'oneliner',
                )
            }),
        ) + \
        HeroMixinAdmin.FIELDSETS + \
        ListableMixinAdmin.FIELDSETS


admin.site.register(models.Author, AuthorAdmin)
