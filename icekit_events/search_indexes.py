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
        if obj.is_upcoming():
            data['boost'] *= 1.25
        return data
