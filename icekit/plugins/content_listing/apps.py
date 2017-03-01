from django.apps import AppConfig


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = "icekit_plugins_content_listing"
    verbose_name = "Collected Content Listing"
