"""
URLconf for ``icekit_events`` app.
"""

# Prefix URL names with the app name. Avoid URL namespaces unless it is likely
# this app will be installed multiple times in a single project.

from django.conf.urls import url

from icekit_events.views import index, event, occurrence

urlpatterns = [
    url(r'^$',
        index, name='icekit_events_index'),
    url(r'^(?P<event_id>[\d]+)/$',
        event, name='icekit_events_event_detail'),
    url(r'^(?P<event_id>[\d]+)/(?P<occurrence_id>[\d]+)/$',
        occurrence, name='icekit_events_occurrence_detail'),
]
