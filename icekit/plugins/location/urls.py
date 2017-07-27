from django.conf.urls import patterns, url

from .views import index, location

urlpatterns = patterns(
    '',
    url(
        r'(?P<slug>[\w-]+)/$', location, name='icekit_plugins_location_detail',
    ),
    url(
        r'$', index, name='icekit_plugins_location_index',
    ),
)
