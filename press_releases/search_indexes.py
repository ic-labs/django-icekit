from haystack import indexes

from . import models


class PressReleaseIndex(indexes.SearchIndex, indexes.Indexable):
    """
    Search index for a fluent page.
    """
    text = indexes.CharField(document=True, use_template=True)
    title = indexes.CharField(model_attr='title', boost=2.0)
    publication_date = indexes.DateTimeField(model_attr='publication_date', null=True)
    url = indexes.CharField(model_attr='get_absolute_url')
    has_url = indexes.BooleanField(model_attr='get_absolute_url')
    # We add this for autocomplete.
    content_auto = indexes.EdgeNgramField(model_attr='title')

    def get_model(self):
        """
        Get the model for the search index.
        """
        return models.PressRelease

    def index_queryset(self, using=None):
        """
        Index on the published objects
        """
        return self.get_model().objects.published()
