"""
URLconf for ``icekit`` app.
"""

# Prefix URL names with the app name. Avoid URL namespaces unless it is likely
# this app will be installed multiple times in a single project.

from django.conf.urls import include, patterns, url

urlpatterns = patterns(
    'icekit.views',
    url(r'^$', 'index', name='icekit_index'),
)
