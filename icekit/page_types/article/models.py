from icekit.content_collections.abstract_models import AbstractListingPage
from plugins.models import AbstractACMILinkItem
from .abstract_models import  AbstractArticle
from django.db import models

class Article(AbstractArticle):
    pass


class ArticleCategoryPage(AbstractListingPage):
    def get_items_to_list(self, request):
        unpublished_pk = self.get_draft().pk
        return Article.objects.published().filter(parent_id=unpublished_pk)

    def get_items_to_mount(self, request):
        unpublished_pk = self.get_draft().pk
        return Article.objects.visible().filter(parent_id=unpublished_pk)


class ArticleLink(AbstractACMILinkItem):
    item = models.ForeignKey("Article")
    class Meta:
        verbose_name = "Article link"
