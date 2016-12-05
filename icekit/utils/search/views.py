from django.conf import settings
from haystack.backends import SQ
from haystack.generic_views import SearchView
from haystack.inputs import AutoQuery
from haystack.query import SearchQuerySet


# convert the subfacet settings to Facet objects
from facets import Facet

SEARCH_SUBFACETS = getattr(settings, "SEARCH_SUBFACETS", {})
for k, kwargs_list in SEARCH_SUBFACETS.items():
    facets = [Facet(**kw) for kw in kwargs_list]
    SEARCH_SUBFACETS[k] = facets


class ICEkitSearchView(SearchView):
    """
    A search view which arranges results according to a top facet ('type'),
    then any of several sets of subfacets, depending on which top facet is
    selected.

    Only zero or one top facet can be active at a time, but many sub-facets
    can be active at a time.

    Counter to Haystack convention, we're not using search logic in the form
    """
    top_facet = Facet(field_name='search_types', is_top_level=True, select_many=False)
    fluent_page = None


    def get_top_level_facet_value(self):
        value = self.request.GET.get(self.top_facet.field_name)
        if value:
            return value
        if self.fluent_page:
            return self.fluent_page.default_search_type or None
        return None

    def pre_facet_sqs(self):
        """
        Return the queryset used for generating facets, before any facets
        are applied
        """
        sqs = SearchQuerySet()

        if self.query:
            sqs = sqs.filter(
                SQ(content=AutoQuery(self.query)) |  # Search `text` document
                SQ(title=AutoQuery(self.query)) |
                SQ(boosted_search_terms=AutoQuery(self.query))
            )

        return sqs

    def get(self, request, *args, **kwargs):
        """User has conducted a search, or default state"""

        form_class = self.get_form_class()
        form = self.get_form(form_class)

        top_value = self.get_top_level_facet_value()
        subfacets = SEARCH_SUBFACETS.get(top_value, [])
        self.active_facets = [self.top_facet] + subfacets

        if form.is_valid():
            self.query = form.cleaned_data.get(self.search_field)
        else:
            self.query = ""

        sqs = self.pre_facet_sqs()

        for facet in self.active_facets:
            sqs = facet.set_on_sqs(sqs)

        facet_counts = sqs.facet_counts()

        for facet in self.active_facets:
            facet.set_values_from_sqs_facet_counts(facet_counts)
            facet.apply_request_and_page_to_values(self.request, self.fluent_page)

        for facet in self.active_facets:
            sqs = facet.narrow_sqs(sqs)

        context = self.get_context_data(**{
            self.form_name: form,
            'facets': self.active_facets,
            'top_facet': self.top_facet,
            'query': self.query,
            'object_list': sqs,
            'page': self.fluent_page,
            'show_placeholders': self.show_placeholders()
        })
        return self.render_to_response(context)

    def show_placeholders(self):
        return not self.query and all([f.is_default() for f in self.active_facets])