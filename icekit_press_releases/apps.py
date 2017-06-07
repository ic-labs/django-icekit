from django.apps import AppConfig

from any_urlfield.forms import SimpleRawIdWidget

from icekit.fields import ICEkitURLField


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = "icekit_press_releases"
    verbose_name = "Press releases"

    def ready(self):
        from .models import PressRelease
        ICEkitURLField.register_model(
            PressRelease, widget=SimpleRawIdWidget(PressRelease),
            title='Press Release')
