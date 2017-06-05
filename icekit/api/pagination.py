from rest_framework.pagination import PageNumberPagination
from rest_framework.settings import api_settings


class DefaultPageNumberPagination(PageNumberPagination):
    """ Default REST pagination settings to apply in ICEkit """
    page_size_query_param = 'page_size'
    max_page_size = api_settings.PAGE_SIZE


class SlowPageNumberPagination(PageNumberPagination):
    """
    Custom REST pagination settings suitable for resources where it can be
    slow, or resource-intensive, to generate API result pages.
    """
    page_size = 1
    page_size_query_param = 'page_size'
    max_page_size = 5
