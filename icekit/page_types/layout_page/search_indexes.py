from haystack import indexes
from icekit.search_indexes import AbstractLayoutIndex

from icekit.utils.search import FluentContentsPageIndexMixin

from . import models


class PageIndex(AbstractLayoutIndex):

    def get_model(self):
        return models.LayoutPage
