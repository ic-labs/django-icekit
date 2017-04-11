from rest_framework import serializers
from rest_framework.settings import api_settings

import rest_framework_filters as filters
from rest_framework import routers

from icekit.api.base_serializers import ModelSubSerializer
from icekit.api.base_views import RedirectViewset
from icekit.api.base_filters import CaseInsensitiveBooleanFilter, \
    WorkHasImagesFilter

from ...api_serializers import WorkCreator, WorkImage
from .models import Artwork as ArtworkModel


class ArtworkDate(ModelSubSerializer):
    class Meta:
        model = ArtworkModel
        source_prefix = 'date_'
        fields = (
            'date_display',
            'date_edtf',
        )


class ArtworkOrigin(ModelSubSerializer):
    class Meta:
        model = ArtworkModel
        source_prefix = 'origin_'
        fields = (
            'origin_continent',
            'origin_country',
            'origin_state_province',
            'origin_city',
            'origin_neighborhood',
            'origin_colloquial',
        )


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


class Artwork(serializers.HyperlinkedModelSerializer):
    creators = WorkCreator(
        source='workcreator_set',
        many=True,
        read_only=True,
    )
    images = WorkImage(
        source="workimage_set",
        many=True,
        read_only=True,
    )
    date = ArtworkDate()
    origin = ArtworkOrigin()
    dimensions = ArtworkDimensions()

    class Meta:
        model = ArtworkModel
        fields = (
            # Relationships
            'creators',
            'images',
            # Sub-resources
            'date',
            'origin',
            'dimensions',
            # Fields
            api_settings.URL_FIELD_NAME,
            'slug',
            'title',
            'subtitle',
            'oneliner',
            'department',
            'medium_display',
            'credit_line',
            'accession_number',
        )
        extra_kwargs = {
            'url': {
                'lookup_field': 'slug',
                'view_name': 'gk_collections_work',
            }
        }


class ArtworkFilter(filters.FilterSet):
    has_images = WorkHasImagesFilter(name='has_images')
    dimensions_is_two_dimensional = \
        CaseInsensitiveBooleanFilter(name='dimensions_is_two_dimensional')

    class Meta:
        model = ArtworkModel


class APIViewSet(RedirectViewset):
    """
    Artwork resource
    """
    queryset = ArtworkModel.objects.all() \
        .prefetch_related('creators', 'images')

    serializer_class = Artwork
    redirect_view_name = 'artwork-api-detail'
    filter_class = ArtworkFilter


router = routers.DefaultRouter()
router.register('artwork', APIViewSet, 'artwork-api')
