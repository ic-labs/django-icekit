from django.db import models
from icekit.content_collections.abstract_models import \
    AbstractCollectedContent, TitleSlugMixin
from icekit.mixins import HeroMixin
from icekit.models import ICEkitFluentContentsMixin


class AbstractArticle(
    ICEkitFluentContentsMixin,
    AbstractCollectedContent,
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
