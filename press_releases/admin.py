from django.contrib import admin
from icekit.admin import FluentLayoutsMixin
from icekit.articles.admin import ArticleAdminBase
from . import models

class PressReleaseAdmin(ArticleAdminBase, FluentLayoutsMixin):
    list_display = ArticleAdminBase.list_display + ('released', 'modified',)
    date_hierarchy = 'released'
    list_filter = ArticleAdminBase.list_filter + ('category',)
    search_fields = ('title', 'id', 'slug',)
    ordering = ('-released', )


class PressContactAdmin(admin.ModelAdmin):
    pass

class PressReleaseCategoryAdmin(admin.ModelAdmin):
    pass


admin.site.register(models.PressRelease, PressReleaseAdmin)
admin.site.register(models.PressContact, PressContactAdmin)
admin.site.register(models.PressReleaseCategory, PressReleaseCategoryAdmin)

