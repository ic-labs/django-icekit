import models
from icekit_events.admin import EventChildModelPlugin, EventWithLayoutsAdmin


class BasicEventPlugin(EventChildModelPlugin):
    model = models.SimpleEvent
    model_admin = EventWithLayoutsAdmin
    sort_priority = 11
