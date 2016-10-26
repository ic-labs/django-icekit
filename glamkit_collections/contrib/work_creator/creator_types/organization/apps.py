from django.apps import AppConfig


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = 'gk_collections_organization'
    verbose_name = "Organization"