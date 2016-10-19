from django.contrib import admin
from icekit.publishing.admin import PublishableFluentContentsAdmin

from .models import Article


class ArticleAdmin(PublishableFluentContentsAdmin):
    prepopulated_fields = {"slug": ("title",)}
    list_filter = PublishableFluentContentsAdmin.list_filter + ('parent', )


admin.site.register(Article, ArticleAdmin)
