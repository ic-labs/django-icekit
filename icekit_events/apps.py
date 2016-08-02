"""
App configuration for ``icekit_events`` app.
"""

# Register signal handlers, but avoid interacting with the database.
# See: https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig.ready

from django.apps import AppConfig
from django.utils.module_loading import autodiscover_modules


class AppConfig(AppConfig):
    name = '_'.join(__name__.split('.')[:-1])
    label = 'icekit_events'

    def ready(self):
        autodiscover_modules('icekit_events_plugins')
