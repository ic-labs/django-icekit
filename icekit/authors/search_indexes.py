from haystack import indexes
from . import models


class AuthorIndex(indexes.SearchIndex, indexes.Indexable):
    """
    Search index for `Author`.
    """
    text = indexes.CharField(document=True, use_template=True)
    name = indexes.CharField(model_attr='get_full_name', boost=2.0)
    url = indexes.CharField(model_attr='get_absolute_url')
    has_url = indexes.BooleanField(model_attr='get_absolute_url')
    # We add this for autocomplete.
    content_auto = indexes.EdgeNgramField(model_attr='get_full_name')

    def get_model(self):
        """
        Get the model for the search index.
        """
        return models.Author
