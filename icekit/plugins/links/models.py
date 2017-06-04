from .abstract_models import AbstractLinkItem
from django.db import models

"""Links to default ICEkit content types"""

class PageLink(AbstractLinkItem):
    item = models.ForeignKey(
        "fluent_pages.Page",
        on_delete=models.CASCADE,
    )

    class Meta:
        verbose_name = "Page link"


class ArticleLink(AbstractLinkItem):
    item = models.ForeignKey(
        "icekit_article.Article",
        on_delete=models.CASCADE,
    )

    class Meta:
        verbose_name = "Article link"


class AuthorLink(AbstractLinkItem):
    item = models.ForeignKey(
        "icekit_authors.Author",
        on_delete=models.CASCADE,
    )

    exclude_from_contributions = models.BooleanField(help_text="Exclude this content "
         "from the author's contributions.", default=False)

    class Meta:
        verbose_name = "Author link"




