from django.apps import AppConfig
from django.utils.module_loading import autodiscover_modules

from any_urlfield.forms import SimpleRawIdWidget

from icekit.fields import ICEkitURLField


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = 'gk_collections_work_creator'
    verbose_name = "Collection"

    def ready(self):
        # look through installed apps to see what work/creator types are
        # registered
        autodiscover_modules('work_type_plugins')
        autodiscover_modules('creator_type_plugins')

        from .models import CreatorBase, WorkBase
        ICEkitURLField.register_model(
            CreatorBase, widget=SimpleRawIdWidget(CreatorBase),
            title='Creator')
        ICEkitURLField.register_model(
            WorkBase, widget=SimpleRawIdWidget(WorkBase), title='Work')
