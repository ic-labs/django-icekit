from django.contrib import admin

from icekit.admin import FluentLayoutsMixin
from icekit.publishing.admin import PublishingAdmin


class PublishableFluentContentsAdmin(PublishingAdmin, FluentLayoutsMixin):
    """
    Add publishing features for non-Page rich content models
    """
    pass


class TitleSlugAdmin(admin.ModelAdmin):
    prepopulated_fields = {"slug": ("title",)}


class PublishableArticleAdmin(PublishableFluentContentsAdmin, TitleSlugAdmin):
    pass
