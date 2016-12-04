from haystack.backends import SQ


class FacetValue(object):
    def __init__(self, facet, value, label, count=None, is_active=False, is_all_results=False, is_default=False):
        self.facet = facet
        self.value = value
        self.label = label
        self.count = count
        self.is_active = is_active
        self.is_all_results = is_all_results
        self.is_default = is_default

    def __repr__(self):
        return u"{0}: '{1}'".format(type(self).__name__, self.value)

    def get_value(self):
        if self.value is None and self.is_all_results and not self.is_default:
            return "ALL"
        return self.value

    def apply_request_and_page(self, request, page=None):
        # decide whether this value is the default for this facet
        if self.facet.is_top_level and page and page.default_search_type:
            if self.value == page.default_search_type:
                self.is_default = True
        elif self.is_all_results:
            self.is_default = True

        # decide whether this value is active
        request_vals = request.GET.getlist(self.facet.field_name)
        if self.value in request_vals:
            self.is_active = True
        elif not request_vals and self.is_default:
            self.is_active = True


class Facet(object):
    def __init__(self, field_name, title="", select_many=False, is_top_level=False):
        self.field_name = field_name
        self.title = title
        self.select_many = select_many
        self.request = None
        self._values = []

        # This is_top_level is a bit hacky - it's used to look at a SearchPage's default setting for the hard-coded top-level `search_type` facet.
        self.is_top_level = is_top_level

    def __repr__(self):
        return u"{0}: for field '{1}'".format(type(self).__name__, self.field_name)

    def set_values_from_sqs_facet_counts(self, sqs_facet_counts):
        """
        Use the sqs.facet_counts() result to set up values and counts.
        """
        self._values = []

        # inject an 'All results' value (if there are other values):
        if sqs_facet_counts.has_key('fields'):
            if not self.select_many and sqs_facet_counts['fields'][self.field_name]:
                self._values += [
                    FacetValue(
                        facet=self,
                        value=None,
                        label="All results",
                        is_all_results=True,
                    )
                ]

            # inject the values from the sqs
            self._values += [
                FacetValue(
                    facet=self,
                    value=value,
                    label=value,
                    count=count
                )
                for value, count in sqs_facet_counts['fields'][self.field_name]
            ]

    def apply_request_and_page_to_values(self, request, page=None):
        """
        Use the request and page config to figure out which values are active
        """
        value_is_set = False
        for value in self._values:
            value.apply_request_and_page(request, page)

    def set_on_sqs(self, sqs):
        return sqs.facet(self.field_name)

    def narrow_sqs(self, sqs):
        """
        TODO: Currently this is an AND conjunction. It should vary depending
        on the value of self.select_many.
        """
        if self.select_many:
            sq = None
            for value in self.get_applicable_values():
                q = SQ(**{self.field_name: sqs.query.clean(value.value)})
                if sq:
                    sq = sq | q
                else:
                    sq = q
            if sq:
                sqs = sqs.narrow(sq)
        else:
            for value in self.get_applicable_values():
                sqs = sqs.narrow(
                    u'%s:"%s"' % (self.field_name, sqs.query.clean(value.value))
                )

        return sqs

    def get_values(self):
        return self._values

    def get_applicable_values(self):
        """Return selected values that will affect the search result"""
        return [v for v in self._values if v.is_active and not v.is_all_results]

    def get_value(self):
        """Returns the label of the first value"""
        try:
            return self.get_applicable_values()[0]
        except IndexError:
            if not self.select_many and self.get_values():
                return self.get_values()[0]


    def is_default(self):
        """Return True if no active values, or if the active value is the default"""
        if not self.get_applicable_values():
            return True

        if self.get_value().is_default:
            return True

        return False

