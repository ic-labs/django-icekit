from icekit.content_collections.abstract_models import AbstractListingPage
from icekit.models import content_link_item_factory
from .abstract_models import  AbstractArticle


class Article(AbstractArticle):
    pass


class ArticleCategoryPage(AbstractListingPage):
    def get_items_to_list(self, request):
        unpublished_pk = self.get_draft().pk
        return Article.objects.published().filter(parent_id=unpublished_pk)

    def get_items_to_mount(self, request):
        unpublished_pk = self.get_draft().pk
        return Article.objects.visible().filter(parent_id=unpublished_pk)


class ArticleLink(content_link_item_factory("icekit_article.Article", verbose_name="Choose article")):
    class Meta:
        verbose_name = "Article link"