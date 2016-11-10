from django.apps import AppConfig

class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = "icekit_plugins_contact_person"
    verbose_name = "Contact person"
    verbose_name_plural = "Contact people"
