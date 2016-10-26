from django.apps import AppConfig
from django.utils.module_loading import autodiscover_modules


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = 'gk_collections_work_creator'
    verbose_name = "Collection"

    def ready(self):
        # look through installed apps to see what event types are registered
        autodiscover_modules('work_type_plugins')
        autodiscover_modules('creator_type_plugins')
