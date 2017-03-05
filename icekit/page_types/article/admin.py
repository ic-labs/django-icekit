from django.contrib import admin
from icekit.admin import ICEkitFluentContentsAdmin

from .models import Article


class ArticleAdmin(ICEkitFluentContentsAdmin):
    prepopulated_fields = {"slug": ("title",)}
    list_filter = ICEkitFluentContentsAdmin.list_filter + ('parent', )


admin.site.register(Article, ArticleAdmin)
