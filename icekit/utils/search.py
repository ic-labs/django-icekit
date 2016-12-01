from django.conf import settings
from django.utils.text import capfirst
from easy_thumbnails.exceptions import InvalidImageFormatError
from easy_thumbnails.files import get_thumbnailer
from fluent_pages.models import UrlNode
from haystack import indexes
from haystack.backends import SQ
from haystack.generic_views import SearchView
from haystack.inputs import AutoQuery
from haystack.forms import SearchForm
from haystack.utils import get_model_ct

SEARCH_SUBFACETS = getattr(settings, "SEARCH_SUBFACETS", {})

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


class ICEkitSearchForm(SearchForm):
    """ Custom search form to use facets and the indexed fields defined above """

    def __init__(self, *args, **kwargs):
        self.applied_facets = kwargs.pop("applied_facets", {})
        super(ICEkitSearchForm, self).__init__(*args, **kwargs)


    def get_searchqueryset(self, query):
        """
        Add non-document fields to search query set so a) they are searched
        when querying, and b) any customisations like `boost` are applied.
        """
        # TODO Find a way to detect all (or boosted) indexed fields across
        # models and automatically add them to this filter, instead of
        # requiring explicit naming of every field to use in the query.
        sqs = self.searchqueryset.all()

        if query:
            sqs = sqs.filter(
                SQ(content=AutoQuery(query)) |  # Search `text` document
                SQ(title=AutoQuery(query)) |
                SQ(boosted_search_terms=AutoQuery(query))
            )

        # take a facet reading *before* applying the facets!
        self.pre_facets = sqs.facet_counts()
        self.pre_facet_count = sqs.count()

        return sqs


    def search(self):
        q = getattr(self, 'cleaned_data', {'q': ''})['q']
        sqs = self.get_searchqueryset(q)

        if self.applied_facets:
            for field, value_list in self.applied_facets.items():
                for value in value_list:
                    if value:
                        sqs = sqs.narrow(u'%s:"%s"' % (field, sqs.query.clean(value)))

        if self.load_all:
            sqs = sqs.load_all()

        return sqs


class ICEkitSearchView(SearchView):
    """
    A search view which arranges results according to a top facet ('type'),
    then any of several sets of subfacets, depending on which top facet is
    selected.

    Only zero or one top facet can be active at a time, but many sub-facets
    can be active at a time.
    """
    form_class = ICEkitSearchForm
    top_facet = {
        'title': '',
        'field_name': 'search_types',
        'select_many': False,
    }

    def get_subfacets(self):
        """
        return a tuple of {'title': , 'facet_field':} dicts describing the
        subfacets that are currently active.
        """
        value = self.request.GET.get(self.top_facet['field_name'])
        return SEARCH_SUBFACETS.get(value, ())

    def get_facet_field_names(self):
        """
        Return a list of facet field names to be applied to the searchqueryset
        """
        r = [self.top_facet['field_name']]
        for subfacet in self.get_subfacets():
            r.append(subfacet['field_name'])

        return r

    def get_form_kwargs(self):
        """Inject any selected facets into the form kwargs"""
        kwargs = super(ICEkitSearchView, self).get_form_kwargs()

        kwargs['applied_facets'] = {}
        for name in self.get_facet_field_names():
            vals = self.request.GET.getlist(name)
            if vals:
                kwargs['applied_facets'][name] = vals

        return kwargs

    def prepare_facet_context(self, sqs_facets):
        """
        A facet is defined by:

        {
            'title': 'Themes',
            'field_name: 'education_themes',
            'select_many': True,
            'values': [
                {'value': 'Technology & Culture, 'count': 36, 'active': True},
                ...
            ]
        }

        This function returns a tuple of relevant facets.
        """

        facets = (self.top_facet,) + self.get_subfacets()
        for facet in facets:
            field_name = facet['field_name']
            facet['values'] = [
                {
                    'value': v,
                    'count': c,
                    'is_active': v in self.request.GET.getlist(field_name),
                } for v, c in sqs_facets['fields'][field_name]
            ]

        return facets


    def get_context_data(self, **kwargs):
        """
        Inject facets and 'page' into the context.
        """
        context = super(ICEkitSearchView, self).get_context_data(**kwargs)
        sqs_facets = kwargs['form'].pre_facets
        context.update({
            'facets': self.prepare_facet_context(sqs_facets),
            'applied_facets': kwargs['form'].applied_facets,
            'pre_facet_count': kwargs['form'].pre_facet_count,
            'page': UrlNode.objects.get_for_path(self.request.path),
        })

        return context

    def get_queryset(self):
        qs = super(ICEkitSearchView, self).get_queryset()
        for field in self.get_facet_field_names():
            qs = qs.facet(field)
        return qs


    def form_invalid(self, form):
        self.queryset = form.search()
        context = self.get_context_data(**{
            self.form_name: form,
            'query': "",
            'object_list': self.queryset
        })
        return self.render_to_response(context)
