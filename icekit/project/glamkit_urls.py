from .urls import urlpatterns
from django.conf.urls import include, patterns, url

urlpatterns += patterns('',
    url(r'^events/', include('icekit_events.urls')),
)
