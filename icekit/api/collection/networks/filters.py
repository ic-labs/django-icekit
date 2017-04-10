import rest_framework_filters as filters

from sfmoma.getty.models import GettyArtistData


class NetworkFilter(filters.FilterSet):
    ulan = filters.AllLookupsFilter(name="ulan")

    class Meta:
        model = GettyArtistData
