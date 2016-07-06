"""
Root URLconf for ``icekit_events.tests`` project.
"""

from django.conf.urls import include, patterns, url
from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns(
    '',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^icekit_events/', include('icekit_events.urls')),
)
