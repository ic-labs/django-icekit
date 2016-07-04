"""
Test models for ``icekit`` app.
"""
from django.db import models

from fluent_pages.extensions import page_type_pool

from icekit import abstract_models
from icekit.page_types.article.abstract_models import AbstractArticlePage
from icekit.plugins import ICEkitFluentContentsPagePlugin


class BaseModel(abstract_models.AbstractBaseModel):
    """
    Concrete base model.
    """
    pass


class FooWithLayout(abstract_models.LayoutFieldMixin):
    pass


class BarWithLayout(abstract_models.LayoutFieldMixin):
    pass


class BazWithLayout(abstract_models.LayoutFieldMixin):
    pass


class ImageTest(models.Model):
    image = models.ImageField(upload_to='testing/')


class ArticleWithRelatedPages(AbstractArticlePage):
    related_pages = models.ManyToManyField('fluent_pages.Page')

    class Meta:
        db_table = 'test_article_with_related'


@page_type_pool.register
class ArticleWithRelatedPagesPlugin(ICEkitFluentContentsPagePlugin):
    """
    ArticlePage implementation as a plugin for use with pages.
    """
    model = ArticleWithRelatedPages
    render_template = 'icekit/page_types/article/default.html'
