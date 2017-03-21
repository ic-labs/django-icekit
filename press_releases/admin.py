from django.contrib import admin
from icekit.admin import ICEkitFluentContentsAdmin

from . import models


class PressReleaseAdmin(ICEkitFluentContentsAdmin):
    list_display = ICEkitFluentContentsAdmin.list_display + ('released', 'modified',)
    date_hierarchy = 'released'
    list_filter = ICEkitFluentContentsAdmin.list_filter + ('category',)
    search_fields = ('title', 'id', 'slug',)
    ordering = ('-released',)
    prepopulated_fields = {'slug': ('title',)}


class PressReleaseCategoryAdmin(admin.ModelAdmin):
    pass


admin.site.register(models.PressRelease, PressReleaseAdmin)
admin.site.register(models.PressReleaseCategory, PressReleaseCategoryAdmin)
