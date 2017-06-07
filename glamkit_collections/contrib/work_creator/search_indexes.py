from haystack import indexes
from icekit.utils.search import AbstractLayoutIndex
from . import models

class WorkIndex(AbstractLayoutIndex, indexes.Indexable):
    def get_model(self):
        return models.WorkBase

class CreatorIndex(AbstractLayoutIndex, indexes.Indexable):
    def get_model(self):
        return models.CreatorBase
