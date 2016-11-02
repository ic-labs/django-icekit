from haystack import indexes

from icekit.utils.search import FluentContentsPageIndexMixin

from . import models


class LayoutPageIndex(indexes.Indexable, FluentContentsPageIndexMixin):

    def get_model(self):
        return models.LayoutPage
