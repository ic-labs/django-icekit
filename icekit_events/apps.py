"""
App configuration for ``icekit_events`` app.
"""

# Register signal handlers, but avoid interacting with the database.
# See: https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig.ready

from django.apps import AppConfig
from django.utils.module_loading import autodiscover_modules

from any_urlfield.forms import SimpleRawIdWidget

from icekit.fields import ICEkitURLField


class AppConfig(AppConfig):
    name = '_'.join(__name__.split('.')[:-1])
    label = 'icekit_events'
    verbose_name = "Events"

    def ready(self):
        # look through installed apps to see what event types are registered
        autodiscover_modules('event_type_plugins')

        from .models import EventBase
        ICEkitURLField.register_model(
            EventBase, widget=SimpleRawIdWidget(EventBase), title='Event')
