from django.contrib import admin

from icekit.admin import FluentLayoutsMixin
from icekit.publishing.admin import PublishingAdmin

class PublishableFluentModelAdmin(PublishingAdmin, FluentLayoutsMixin):
    """
    Add publishing features for non-Page rich content models
    """
    pass


class TitleSlugAdmin(admin.ModelAdmin):
    prepopulated_fields = {"slug": ("title",)}


class PublishableArticleAdmin(PublishableFluentModelAdmin, TitleSlugAdmin):
    pass
