from django.apps import apps

from rest_framework import viewsets

from icekit.utils.pagination import ICEKitAPIPagination

from . import serializers


Image = apps.get_model('icekit_plugins_image.Image')


class ImageViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Read only viewset for image objects.
    """
    pagination_class = ICEKitAPIPagination
    serializer_class = serializers.ImageSerializer
    # NOTE: `get_queryset` method is used instead of this `queryset` class
    # attribute to return results, but we still need this defined here so
    # the API router can auto-generate the right endpoint URL.
    queryset = Image.objects.all()

    def get_queryset(self):
        return Image.objects.all()
