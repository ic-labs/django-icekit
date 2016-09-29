from .plugins import EventChildModelPlugin

from . import admin, models


class EventPlugin(EventChildModelPlugin):
    model = models.Event
    model_admin = admin.EventChildAdmin


class EventPagePlugin(EventChildModelPlugin):
    model = models.EventPage
    model_admin = admin.EventPageChildAdmin
