from django.db import models
from icekit.content_collections.abstract_models import \
    AbstractCollectedContent, AbstractListingPage, TitleSlugMixin
from icekit.mixins import ListableMixin, HeroMixin
from icekit.publishing.models import PublishableFluentContents


class AbstractArticle(
    PublishableFluentContents,
    AbstractCollectedContent,
    ListableMixin,
    HeroMixin,
    TitleSlugMixin
):
    parent = models.ForeignKey(
        'ArticleCategoryPage',
        verbose_name="Parent listing page",
        limit_choices_to={'publishing_is_draft': True},
        on_delete=models.PROTECT,
    )

    class Meta:
        unique_together = (('slug', 'parent', 'publishing_linked'), )
        abstract = True
