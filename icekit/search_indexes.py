from fluent_pages.pagetypes.flatpage.models import FlatPage
from fluent_pages.pagetypes.fluentpage.models import FluentPage
from haystack import indexes


class FluentPageIndex(indexes.SearchIndex, indexes.Indexable):
    """
    Search index for a fluent page.
    """
    text = indexes.CharField(document=True, use_template=True)
    author = indexes.CharField(model_attr='author')
    publication_date = indexes.DateTimeField(model_attr='publication_date', null=True)

    @staticmethod
    def get_model():
        """
        Get the model for the search index.
        """
        return FluentPage

    def index_queryset(self, using=None):
        """
        Queryset appropriate for this object to allow search for.
        """
        return self.get_model().objects.published()


class FlatPageIndex(FluentPageIndex):
    """
    Search index for a flat page.

    As everything except the model is the same as for a FluentPageIndex
    we shall subclass it and overwrite the one part we need.
    """
    @staticmethod
    def get_model():
        """
        Get the model for the search index.
        """
        return FlatPage
