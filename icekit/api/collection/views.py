from sfmoma.getty.models import GettyArtistData, GettyRelationships

from ..base_views import RedirectViewset

from . import exhibitions
from . import networks
from . import relationships


class ExhibitionViewSet(RedirectViewset):
    """
    Exhibition resource.
    """
    queryset = ExhibitionModel.objects.filter(is_at_sfmoma=True)

    serializer_class = exhibitions.serializers.Exhibition
    filter_class = exhibitions.filters.ExhibitionFilter
    redirect_view_name = 'exhibition-detail'
    ordering_fields = (
            'title',
            'slug',
            'start_date',
            'end_date',
    )


class NetworkViewSet(RedirectViewset):
    queryset = GettyArtistData.objects.all()
    serializer_class = networks.serializers.ArtistNetwork
    filter_class = networks.filters.NetworkFilter


class RelationshipViewSet(RedirectViewset):
    queryset = GettyRelationships.objects.all()
    serializer_class = relationships.serializers.RelationshipDescriptions
    filter_class = relationships.filters.RelationshipFilter
