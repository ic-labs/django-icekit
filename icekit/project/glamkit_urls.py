from .urls import urlpatterns
from django.conf.urls import include, patterns, url

# inject just before the final catch-all
urlpatterns = urlpatterns[:-1] + patterns('',
    url(r'^events/', include('icekit_events.urls')),
) + urlpatterns[-1:]
