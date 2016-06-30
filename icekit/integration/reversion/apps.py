from django.apps import AppConfig


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = 'icekit_integration_reversion'
    verbose_name = 'ICEkit Reversion Integration'
