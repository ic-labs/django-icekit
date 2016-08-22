from fluent_pages.models import Page
from rest_framework import viewsets

from . import serializers
from .pagination import ICEKitPagination


class PageViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Read only viewset for published page objects.
    """
    pagination_class = ICEKitPagination
    serializer_class = serializers.PageSerializer
    # NOTE: `get_queryset` method is used instead of this `queryset` class
    # attribute to return results, but we still need this defined here so
    # the API router can auto-generate the right page endpoint URL.
    queryset = Page.objects

    def get_queryset(self):
        return Page.objects.published()
