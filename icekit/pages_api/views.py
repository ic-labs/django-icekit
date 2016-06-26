from fluent_pages.models import Page
from rest_framework import viewsets

from . import serializers
from .pagination import ICEKitPagination


class PageViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Read only viewset for published page objects.

    It will exclude StoryPages if they exist as they live at a separate
    API endpoint.
    """
    pagination_class = ICEKitPagination
    queryset = Page.objects.published()
    serializer_class = serializers.PageSerializer
