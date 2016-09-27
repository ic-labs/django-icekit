from django.contrib import admin

from icekit.publishing.admin import PublishableFluentContentsAdmin


class TitleSlugAdmin(admin.ModelAdmin):
    prepopulated_fields = {"slug": ("title",)}


class PublishableArticleAdmin(PublishableFluentContentsAdmin, TitleSlugAdmin):
    pass
