from haystack import indexes
from icekit.utils.search import AbstractLayoutIndex
from . import models

class AuthorIndex(AbstractLayoutIndex, indexes.Indexable):
    def get_model(self):
        return models.Author
