from django.apps import apps

from rest_framework import serializers
from drf_queryfields import QueryFieldsMixin


MediaCategory = apps.get_model('icekit.MediaCategory')


class MediaCategorySerializer(QueryFieldsMixin, serializers.ModelSerializer):
    """
    A serializer for an ICEkit MediaCategory.
    """
    class Meta:
        model = MediaCategory
        fields = ['id', 'name']
