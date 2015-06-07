"""
App configuration for ``eventkit.plugins.fluentevent`` app.
"""

# Register signal handlers, but avoid interacting with the database.
# See: https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig.ready

from django.apps import AppConfig


class AppConfig(AppConfig):
    name = 'eventkit.plugins.fluentevent'
    label = 'eventkit_fluentevent'
