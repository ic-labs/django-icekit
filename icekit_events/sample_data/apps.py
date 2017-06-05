"""
App configuration for ``icekit_events.sample_data`` app.
"""

# Register signal handlers, but avoid interacting with the database.
# See: https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig.ready

from django.apps import AppConfig


class AppConfig(AppConfig):
    name = 'icekit_events.sample_data'
    label = 'icekit_events_sample_data'
