import rest_framework_filters as filters
from rest_framework import routers

from icekit.api.base_serializers import ModelSubSerializer
from icekit.api.base_views import ModelViewSet
from icekit.api.base_filters import CaseInsensitiveBooleanFilter, \
    WorkHasImagesFilter

from ...api_serializers import Work
from .models import Artwork as ArtworkModel


VIEWNAME = 'artwork-api'


class ArtworkDimensions(ModelSubSerializer):
    class Meta:
        model = ArtworkModel
        source_prefix = 'dimensions_'
        fields = (
            'dimensions_display',
            'dimensions_is_two_dimensional',
            'dimensions_extent',
            'dimensions_height_cm',
            'dimensions_width_cm',
            'dimensions_depth_cm',
            'dimensions_weight_kg',
        )


class Artwork(Work):
    dimensions = ArtworkDimensions()

    class Meta:
        model = ArtworkModel
        fields = Work.Meta.fields + (
            # Sub-resources
            'dimensions',
            # Fields
            'medium_display',
        )
        extra_kwargs = {
            'url': {
                'lookup_field': 'pk',
                'view_name': 'api:%s-detail' % VIEWNAME,
            }
        }


class ArtworkFilter(filters.FilterSet):
    has_images = WorkHasImagesFilter(name='has_images')
    dimensions_is_two_dimensional = \
        CaseInsensitiveBooleanFilter(name='dimensions_is_two_dimensional')

    class Meta:
        model = ArtworkModel


class APIViewSet(ModelViewSet):
    """
    Artwork resource
    """
    queryset = ArtworkModel.objects.all() \
        .prefetch_related('creators', 'images')

    serializer_class = Artwork
    filter_class = ArtworkFilter


router = routers.DefaultRouter()
router.register('artwork', APIViewSet, VIEWNAME)
