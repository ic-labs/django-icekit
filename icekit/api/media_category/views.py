from django.apps import apps

from rest_framework import viewsets

from icekit.utils.pagination import ICEKitAPIPagination

from . import serializers


MediaCategory = apps.get_model('icekit.MediaCategory')


class MediaCategoryViewSet(viewsets.ModelViewSet):
    """
    Read and write viewset for image objects.
    """
    pagination_class = ICEKitAPIPagination
    serializer_class = serializers.MediaCategorySerializer
    # NOTE: `get_queryset` method is used instead of this `queryset` class
    # attribute to return results, but we still need this defined here so
    # the API router can auto-generate the right endpoint URL and apply
    # `DjangoModelPermissions`.
    queryset = MediaCategory.objects.none()

    def get_queryset(self):
        return MediaCategory.objects.all()
