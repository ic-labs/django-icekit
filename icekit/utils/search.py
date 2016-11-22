from easy_thumbnails.exceptions import InvalidImageFormatError
from easy_thumbnails.files import get_thumbnailer
from haystack import indexes
from haystack.backends import SQ
from haystack.inputs import AutoQuery
from haystack.forms import ModelSearchForm
from haystack.utils import get_model_ct
from icekit.mixins import LayoutFieldMixin


# Doesn't extend `indexes.Indexable` to avoid auto-detection for 'Search In'
class AbstractLayoutIndex(indexes.SearchIndex):
    """
    A search index for a publishable polymorphic model that implements
    ListableMixin and LayoutFieldMixin.

    Subclasses will need to mix in `indexes.Indexable` and implement
    `get_model(self)`. They may need to override the `text` field to specify
    a different template name.

    Derived classes must override the `get_model()` method to return the
    specific class (not an instance) that the search index will use.
    """
    # Content
    text = indexes.CharField(document=True, use_template=True, template_name="search/indexes/icekit/default.txt")
    get_type = indexes.CharField(model_attr='get_type')
    get_title = indexes.CharField(model_attr='get_title', boost=2.0)
    get_oneliner = indexes.CharField(model_attr='get_oneliner')
    boosted_search_terms = indexes.CharField(model_attr="get_boosted_search_terms", boost=2.0, null=True)

    # Meta
    get_absolute_url = indexes.CharField(model_attr='get_absolute_url')
    get_list_image_url = indexes.CharField()
    modification_date = indexes.DateTimeField(model_attr='modification_date')
    language_code = indexes.CharField(model_attr='language_code')

    # SEO Translations
    meta_keywords = indexes.CharField(model_attr='meta_keywords')
    meta_description = indexes.CharField(model_attr='meta_description')
    meta_title = indexes.CharField(model_attr='meta_title')

    # We add this for autocomplete.
    content_auto = indexes.EdgeNgramField(model_attr='get_title')

    def index_queryset(self, using=None):
        """
        Index current language translation of published objects.

        TODO: Find a way to index all translations of the given model, not just
        the current site language's translation.
        """
        return self.get_model().objects.published().language()

    def full_prepare(self, obj):
        """
        Make django_ct equal to the type of get_model, to make polymorphic
        children show up in results.
        """
        prepared_data = super(AbstractLayoutIndex, self).full_prepare(obj)
        prepared_data['django_ct'] = get_model_ct(self.get_model())
        return prepared_data

    def prepare_get_list_image_url(self, obj):
        list_image = getattr(obj, "get_list_image", lambda x: None)()
        if list_image:
            # resize according to the `list_image` alias
            try:
                return get_thumbnailer(list_image)['list_image'].url
            except InvalidImageFormatError:
                pass
        return ""


class ICEkitSearchForm(ModelSearchForm):
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
