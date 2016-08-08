from __future__ import unicode_literals

from django.apps import AppConfig


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])  # Name of package where `apps` module is located

