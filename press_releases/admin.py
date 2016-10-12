from django.contrib import admin
from icekit.publishing.admin import PublishingAdmin

from icekit.admin_mixins import FluentLayoutsMixin
from . import models

class PressReleaseAdmin(PublishingAdmin, FluentLayoutsMixin):
    list_display = PublishingAdmin.list_display + ('released', 'modified',)
    date_hierarchy = 'released'
    list_filter = PublishingAdmin.list_filter + ('category',)
    search_fields = ('title', 'id', 'slug',)
    ordering = ('-released', )
    prepopulated_fields = {'slug': ('title',)}


class PressContactAdmin(admin.ModelAdmin):
    pass

class PressReleaseCategoryAdmin(admin.ModelAdmin):
    pass


admin.site.register(models.PressRelease, PressReleaseAdmin)
admin.site.register(models.PressContact, PressContactAdmin)
admin.site.register(models.PressReleaseCategory, PressReleaseCategoryAdmin)

