from django.apps import AppConfig


class PagesAPIConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])  # Package with `apps` module
    label = '_'.join(__name__.split('.')[:-1])
    verbose_name = 'PagesAPI'
