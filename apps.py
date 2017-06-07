from django.apps import AppConfig

class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = "glamkit_sponsors"
    verbose_name = "Sponsors"
