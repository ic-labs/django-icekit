"""
App configuration for ``eventkit.sample_data`` app.
"""

# Register signal handlers, but avoid interacting with the database.
# See: https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig.ready

from django.apps import AppConfig


class AppConfig(AppConfig):
    name = 'eventkit.sample_data'
    label = 'eventkit_sample_data'
