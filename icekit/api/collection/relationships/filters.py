import rest_framework_filters as filters

from sfmoma.getty.models import GettyRelationships


class RelationshipFilter(filters.FilterSet):
    relationship_id = filters.AllLookupsFilter(name="id")

    class Meta:
        model = GettyRelationships
