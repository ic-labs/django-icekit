from django.db.models import Prefetch

from glamkit_collection.models import ArtworkArtist as ArtworkArtistModel, \
    Artist as ArtistModel, Artwork as ArtworkModel, \
    Exhibition as ExhibitionModel

from sfmoma.getty.models import GettyArtistData, GettyRelationships

from ..base_views import RedirectViewset

from . import artists
from . import exhibitions
from . import networks
from . import relationships


class ArtistViewSet(RedirectViewset):
    """
    Artist resource.
    """
    queryset = ArtistModel.objects.all().prefetch_related(Prefetch(
        'artworkartist_set',
        queryset=ArtworkArtistModel.objects.select_related('artwork')
    ))

    serializer_class = artists.serializers.Artist
    redirect_view_name = 'artist-detail'
    filter_class = artists.filters.ArtistFilter
    ordering_fields = (
            'name_display',
            'name_sort',
            'name_given',
            'name_family',

            'life_info_birth_date_sort_earliest',
            'life_info_birth_date_sort_latest',
            'life_info_death_date_sort_earliest',
            'life_info_death_date_sort_latest',

            'background_country',
            'background_continent',
    )




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
