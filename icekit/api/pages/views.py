from fluent_pages.models import Page

from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from rest_framework.decorators import permission_classes

from . import serializers
from icekit.utils.pagination import ICEKitAPIPagination


@permission_classes((AllowAny, ))
class PageViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Read only viewset for published page objects.
    """
    pagination_class = ICEKitAPIPagination
    serializer_class = serializers.PageSerializer
    # NOTE: `get_queryset` method is used instead of this `queryset` class
    # attribute to return results, but we still need this defined here so
    # the API router can auto-generate the right page endpoint URL.
    queryset = Page.objects

    def get_queryset(self):
        return Page.objects.published()
