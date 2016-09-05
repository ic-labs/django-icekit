from django.contrib import admin

from icekit.articles.admin import PublishableArticleAdmin
from .models import Article


class ArticleAdmin(PublishableArticleAdmin):
    pass

admin.site.register(Article, ArticleAdmin)
