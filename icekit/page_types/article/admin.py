from django.contrib import admin
from icekit.admin import ICEkitFluentContentsAdmin
from icekit.admin_tools.mixins import HeroMixinAdmin, ListableMixinAdmin
from . import models

class ArticleAdmin(
    ICEkitFluentContentsAdmin,
    HeroMixinAdmin,
    ListableMixinAdmin,
):
    prepopulated_fields = {"slug": ("title",)}
    list_filter = ICEkitFluentContentsAdmin.list_filter + ('parent', )

    raw_id_fields = HeroMixinAdmin.raw_id_fields

    fieldsets = (
            (None, {
                'fields': (
                    'title',
                    'slug',
                    'parent',
                )
            }),
        ) + \
        HeroMixinAdmin.FIELDSETS + \
        ListableMixinAdmin.FIELDSETS


# admin.site.register(models.Article, ArticleAdmin)
