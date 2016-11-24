from django.apps import AppConfig

from any_urlfield.forms import SimpleRawIdWidget

from icekit.fields import ICEkitURLField


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = 'icekit_authors'
    verbose_name = "Authors"

    def ready(self):
        from .models import Author
        ICEkitURLField.register_model(
            Author, widget=SimpleRawIdWidget(Author), title='Author')
