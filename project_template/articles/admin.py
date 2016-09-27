from django.contrib import admin
from icekit.admin import FluentLayoutsMixin
from icekit.articles.admin import PolymorphicArticleParentAdmin, \
    PolymorphicArticleChildAdmin
from .models import Article, LayoutArticle, RedirectArticle


class ArticleChildAdmin(PolymorphicArticleChildAdmin):
    base_model = Article


class LayoutArticleAdmin(ArticleChildAdmin, FluentLayoutsMixin):
    base_model=LayoutArticle


class RedirectArticleAdmin(ArticleChildAdmin):
    base_model=RedirectArticle


@admin.register(Article)
class ArticleParentAdmin(PolymorphicArticleParentAdmin):
    base_model = Article
    child_models = ((LayoutArticle, LayoutArticleAdmin),
                    (RedirectArticle, RedirectArticleAdmin),)
