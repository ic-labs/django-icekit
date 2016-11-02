from haystack import indexes

from icekit.publishing.models import PublishableFluentContentsPage


# Doesn't extend `indexes.Indexable` to avoid auto-detection for 'Search In'
class FluentContentsPageIndexMixin(indexes.SearchIndex):
    """
    Base search index class for a publishable fluent contents page.

    Derived classes must override the `get_model()` method to return the
    specific class (not an instance) that the search index will use.
    """
    text = indexes.CharField(document=True, use_template=True)
    title = indexes.CharField(model_attr='title', boost=2.0)
    slug = indexes.CharField(model_attr='slug')
    url = indexes.CharField(model_attr='get_absolute_url')
    author = indexes.CharField()
    modification_date = indexes.DateTimeField(model_attr='modification_date')

    language_code = indexes.CharField(model_attr='language_code')

    boosted_search_terms = indexes.CharField(boost=2.0, null=True)

    # SEO Translations
    meta_keywords = indexes.CharField(model_attr='meta_keywords')
    meta_description = indexes.CharField(model_attr='meta_description')
    meta_title = indexes.CharField(model_attr='meta_title')

    def get_model(self):
        """
        Get the model for the search index.
        """
        return PublishableFluentContentsPage

    def index_queryset(self, using=None):
        """
        Index current language translation of published pages.

        TODO: Find a way to index all translations of the given model, not just
        the current site language's translation.
        """
        return self.get_model().objects.published().language()

    def prepare_author(self, obj):
        return obj.author.get_full_name()

    def prepare_boosted_search_terms(self, obj):
        return getattr(obj, 'boosted_search_terms', '')
