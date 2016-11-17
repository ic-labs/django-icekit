from .abstract_models import AbstractLinkItem
from django.db import models

"""Links to default ICEkit content types"""

class PageLink(AbstractLinkItem):
    item = models.ForeignKey("fluent_pages.Page")

    class Meta:
        verbose_name = "Page link"


class ArticleLink(AbstractLinkItem):
    item = models.ForeignKey("icekit_article.Article")

    class Meta:
        verbose_name = "Article link"


class AuthorLink(AbstractLinkItem):
    item = models.ForeignKey("icekit_authors.Author")

    class Meta:
        verbose_name = "Author link"




