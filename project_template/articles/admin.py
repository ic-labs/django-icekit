from django.contrib import admin
from icekit.publishing.admin import PublishableFluentContentsAdmin
from .models import Article


class ArticleAdmin(PublishableFluentContentsAdmin):
    prepopulated_fields = {"slug": ("title",)}

admin.site.register(Article, ArticleAdmin)
