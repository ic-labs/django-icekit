import forms_builder.forms.urls
from django.conf.urls import patterns, url, include
from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns(
    '',
    url(r'^admin/', include(admin.site.urls)),
    # url(r'^forms/', include(forms_builder.forms.urls)),
    url(r'^404/$', 'icekit.response_pages.views.page_not_found', name='404'),
    url(r'^500/$', 'icekit.response_pages.views.server_error', name='500'),
    url(r'api/pages/', include('icekit.pages_api.urls')),
    url(r'', include('icekit.urls')),
    url(r'', include('fluent_pages.urls')),
)
