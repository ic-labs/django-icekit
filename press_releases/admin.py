from django.contrib import admin
from icekit.articles.admin import PublishableArticleAdmin
from . import models

class PressReleaseAdmin(PublishableArticleAdmin):
    list_display = PublishableArticleAdmin.list_display + ('released', 'modified',)
    date_hierarchy = 'released'
    list_filter = PublishableArticleAdmin.list_filter + ('category',)
    search_fields = ('title', 'id', 'slug',)
    ordering = ('-released', )


class PressContactAdmin(admin.ModelAdmin):
    pass

class PressReleaseCategoryAdmin(admin.ModelAdmin):
    pass


admin.site.register(models.PressRelease, PressReleaseAdmin)
admin.site.register(models.PressContact, PressContactAdmin)
admin.site.register(models.PressReleaseCategory, PressReleaseCategoryAdmin)

