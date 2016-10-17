from django.apps import AppConfig


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = "icekit_plugins_oembed_with_caption"
    verbose_name = "Media embed with caption"
