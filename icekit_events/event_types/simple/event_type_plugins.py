import models
from icekit_events.admin import EventChildModelPlugin


class BasicEventPlugin(EventChildModelPlugin):
    model = models.SimpleEvent
