"""
URLconf for ``icekit_events`` app.
"""

# Prefix URL names with the app name. Avoid URL namespaces unless it is likely
# this app will be installed multiple times in a single project.

from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^work/(?P<slug>[\w-]+)/$',
        views.work, name='gk_collections_work'),
    url(r'^creator/(?P<slug>[\w-]+)/$',
        views.creator, name='gk_collections_creator'),
]
