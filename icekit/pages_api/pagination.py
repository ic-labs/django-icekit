from rest_framework.pagination import PageNumberPagination


class ICEKitPagination(PageNumberPagination):
    """
    Default API pagination configuration for ICEKit.
    """
    page_size = 5
