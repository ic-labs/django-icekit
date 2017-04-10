import rest_framework_filters as filters

from glamkit_collection.models import EmbarkExhibition as ExhibitionModel


class ExhibitionFilter(filters.FilterSet):
    title = filters.AllLookupsFilter(name="title")
    slug = filters.AllLookupsFilter(name="slug")
    start_date = filters.AllLookupsFilter(name="start_date")
    end_date = filters.AllLookupsFilter(name="end_date")

    class Meta:
        model = ExhibitionModel
