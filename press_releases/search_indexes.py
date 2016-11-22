from haystack import indexes
from icekit.utils.search import AbstractLayoutIndex
from . import models

class PressReleaseIndex(AbstractLayoutIndex, indexes.Indexable):
    def get_model(self):
        return models.PressRelease
