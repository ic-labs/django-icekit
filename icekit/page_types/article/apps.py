from django.apps import AppConfig

from any_urlfield.forms import SimpleRawIdWidget

from icekit.fields import ICEkitURLField


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = 'icekit_article'
    verbose_name = 'Articles'

    def ready(self):
        from .models import Article
        ICEkitURLField.register_model(
            Article, widget=SimpleRawIdWidget(Article), title='Article')
