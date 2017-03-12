from django.conf.urls import include, patterns, url

from .views import iiif_image_api_info, iiif_image_api

urlpatterns = patterns(
    '',
    url(
        r'(?P<identifier_param>.+)/info.json',
        iiif_image_api_info,
        name='iiif_image_api_info',
    ),
    url(
        r'(?P<identifier_param>[^/]+)/(?P<region_param>[^/]+)'
        r'/(?P<size_param>[^/]+)/(?P<rotation_param>[^/]+)'
        r'/(?P<quality_param>[^.]+).(?P<format_param>.+)',
        iiif_image_api,
        name='iiif_image_api',
    ),
)
