import haystack
from haystack import indexes
from icekit.utils.search import AbstractLayoutIndex
from . import models

class EventBaseIndex(AbstractLayoutIndex, indexes.Indexable):
    def get_model(self):
        return models.EventBase

    def prepare_search_types(self, obj):
        return ["Events"]

    def prepare(self, obj):
        data = super(EventBaseIndex, self).prepare(obj)
        data['boost'] = 1.2
        return data
