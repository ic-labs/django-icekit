from rest_framework import serializers
from rest_framework.settings import api_settings

from glamkit_collection.models import EmbarkExhibition as ExhibitionModel


# class ExhibitionArtworkSummary(serializers.HyperlinkedModelSerializer):
#     """
#     Minimal artwork data
#     """
#     class Meta:
#         model = ArtworkModel
#         fields = (
#             api_settings.URL_FIELD_NAME,
#             'slug',
#             'url',
#             'title_display',
#             'date_display',
#         )
#         extra_kwargs = {
#             'url': {'lookup_field': 'slug'}
#         }


class Exhibition(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ExhibitionModel
        fields = (
            api_settings.URL_FIELD_NAME,
            'title',
            'slug',
            'start_date',
            'end_date',
            # 'works',
        )
        extra_kwargs = {
            'url': {'lookup_field': 'slug'}
        }
