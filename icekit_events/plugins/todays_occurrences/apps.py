from django.apps import AppConfig


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = "ik_events_todays_occurrences"
    verbose_name = "today's occurrences"
