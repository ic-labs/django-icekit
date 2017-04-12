from django.apps import AppConfig
from django.utils.module_loading import autodiscover_modules

from any_urlfield.forms import SimpleRawIdWidget

from icekit.fields import ICEkitURLField


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = 'glamkit_collections'
    verbose_name = "Collection"
