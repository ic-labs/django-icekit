from django.conf.urls import patterns, url, include
from icekit.project.urls import urlpatterns

urlpatterns = patterns(
    '',
    # API is made available at api.HOSTNAME domain by `icekit.project.hosts`
    # normally, but this is a massive PITA to get working for unit tests so
    # here we're punting and just using standard URL paths.
    url(r'^api/', include('icekit.api.urls')),

    url(r'^404/$', 'icekit.response_pages.views.page_not_found', name='404'),
    url(r'^500/$', 'icekit.response_pages.views.server_error', name='500'),
    url(r'^', include(urlpatterns)),
)
