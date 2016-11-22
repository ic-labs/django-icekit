from haystack import indexes
from icekit.utils.search import AbstractLayoutIndex
from . import models

class EventBase(AbstractLayoutIndex, indexes.Indexable):
    def get_model(self):
        return models.EventBase
