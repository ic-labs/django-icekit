from django.apps import apps

from rest_framework import serializers


MediaCategory = apps.get_model('icekit.MediaCategory')


class MediaCategorySerializer(serializers.ModelSerializer):
    """
    A serializer for an ICEkit MediaCategory.
    """
    class Meta:
        model = MediaCategory
        fields = ['id', 'name']
