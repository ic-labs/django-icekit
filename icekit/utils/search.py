from haystack import indexes
from haystack.backends import SQ
from haystack.inputs import AutoQuery
from haystack.forms import ModelSearchForm

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


class FluentContentsPageModelSearchForm(ModelSearchForm):
    """ Custom search form to use the indexed fields defined above """

    def get_searchqueryset(self, query):
        """
        Add non-document fields to search query set so a) they are searched
        when querying, and b) any customisations like `boost` are applied.
        """
        # TODO Find a way to detect all indexed fields across models and
        # automatically add them to this filter, instead of requiring explicit
        # naming of every indexed field.
        return self.searchqueryset.filter(
            SQ(content=AutoQuery(query)) |  # Search `text` document
            SQ(title=AutoQuery(query)) |
            SQ(slug=AutoQuery(query)) |
            SQ(author=AutoQuery(query)) |

            SQ(boosted_search_terms=AutoQuery(query)) |

            SQ(meta_keywords=AutoQuery(query)) |
            SQ(meta_description=AutoQuery(query)) |
            SQ(meta_title=AutoQuery(query))
        )

    # TODO This is mostly a copy/paste of `haystack.forms:SearchForm.search`
    # and `haystack.forms.ModelSearchForm.search` except for customisation of
    # the `SearchQuerySet` to include our fields. There should be a better way
    # of doing this, though this is what the docs recommend:
    # http://django-haystack.readthedocs.io/en/v2.5.1/boost.html
    def search(self):
        if not self.is_valid():
            return self.no_query_found()

        if not self.cleaned_data.get('q'):
            return self.no_query_found()

        q = self.cleaned_data['q']

        #######################################################################
        # Customised
        sqs = self.get_searchqueryset(q)
        #######################################################################

        if self.load_all:
            sqs = sqs.load_all()

        #######################################################################
        # Customised - per `ModelSearchForm.search()`
        sqs = sqs.models(*self.get_models())
        #######################################################################

        return sqs
