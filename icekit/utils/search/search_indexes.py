from django.utils.text import capfirst
from easy_thumbnails.exceptions import InvalidImageFormatError
from easy_thumbnails.files import get_thumbnailer
from haystack import indexes
from haystack.utils import get_model_ct


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
    get_type = indexes.CharField()
    get_title = indexes.CharField(model_attr='get_title', boost=2.0)
    get_oneliner = indexes.CharField(model_attr='get_oneliner')
    boosted_search_terms = indexes.CharField(model_attr="get_boosted_search_terms", boost=2.0, null=True)

    # Meta
    get_absolute_url = indexes.CharField(model_attr='get_absolute_url')
    get_list_image_url = indexes.CharField()
    modification_date = indexes.DateTimeField()
    language_code = indexes.CharField()

    # SEO Translations
    meta_keywords = indexes.CharField()
    meta_description = indexes.CharField()
    meta_title = indexes.CharField()

    # We add this for autocomplete.
    content_auto = indexes.EdgeNgramField(model_attr='get_title')

    # facets
    # top-level result type
    search_types = indexes.MultiValueField(faceted=True)

    def index_queryset(self, using=None):
        """
        Index published objects.

        """
        return self.get_model().objects.published().select_related()

    def full_prepare(self, obj):
        """
        Make django_ct equal to the type of get_model, to make polymorphic
        children show up in results.
        """
        prepared_data = super(AbstractLayoutIndex, self).full_prepare(obj)
        prepared_data['django_ct'] = get_model_ct(self.get_model())
        return prepared_data

    def prepare_get_type(self, obj):
        if hasattr(obj, 'get_type'):
            return unicode(obj.get_type())
        return ""

    def prepare_get_list_image_url(self, obj):
        list_image = getattr(obj, "get_list_image", lambda x: None)()
        if list_image:
            # resize according to the `list_image` alias
            try:
                return get_thumbnailer(list_image)['list_image'].url
            except InvalidImageFormatError:
                pass
        return ""

    def prepare_modification_date(self, obj):
        return getattr(obj, "modification_date", None)

    def prepare_language_code(self, obj):
        return getattr(obj, "language_code", None)

    def prepare_meta_keywords(self, obj):
        return getattr(obj, "meta_keywords", None)

    def prepare_meta_description(self, obj):
        return getattr(obj, "meta_description", None)

    def prepare_meta_title(self, obj):
        return getattr(obj, "meta_title", None)

    def prepare_search_types(self, obj):
        r = [capfirst(obj.get_type_plural())]
        if hasattr(obj, 'is_educational') and obj.is_educational():
            r.append('Education')
        return r

    def prepare(self, obj):
        data = super(AbstractLayoutIndex, self).prepare(obj)
        # ensure default boost amount for field_value_factor calculations.
        if not data.has_key('boost'):
            data['boost'] = 1.0
        return data
