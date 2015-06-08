"""
App configuration for ``icekit`` app.
"""

# Register signal handlers, but avoid interacting with the database.
# See: https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig.ready

from django.apps import AppConfig
from django.utils.module_loading import autodiscover_modules


class AppConfig(AppConfig):
    name = 'icekit'

    def ready(self):
        """
        Import plugins from installed apps.
        """
        autodiscover_modules('plugins')
