from django.apps import AppConfig


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])  # Portable
    label = 'icekit_dashboard'

    verbose_name = 'Dashboard'
