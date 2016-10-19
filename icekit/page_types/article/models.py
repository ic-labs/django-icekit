from django.db import models
from icekit.content_collections.abstract_models import \
    AbstractCollectedContent, AbstractListingPage, TitleSlugMixin
from icekit.publishing.models import PublishableFluentContents


class ArticleCategoryPage(AbstractListingPage):
    def get_items_to_list(self, request):
        unpublished_pk = self.get_draft().pk
        return Article.objects.published().filter(parent_id=unpublished_pk)

    def get_items_to_mount(self, request):
        unpublished_pk = self.get_draft().pk
        return Article.objects.visible().filter(parent_id=unpublished_pk)

    class Meta:
        verbose_name = "Article category page"


class Article(
        PublishableFluentContents, AbstractCollectedContent, TitleSlugMixin):
    parent = models.ForeignKey(
        'ArticleCategoryPage',
        limit_choices_to={'publishing_is_draft': True},
        on_delete=models.PROTECT,
    )

    class Meta:
        unique_together = (('slug', 'parent', 'publishing_linked'), )
