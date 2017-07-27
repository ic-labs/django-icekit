from icekit_events.admin import EventChildModelPlugin

import models
import admin


class BasicEventPlugin(EventChildModelPlugin):
    model = models.SimpleEvent
    model_admin = admin.SimpleEventAdmin
    sort_priority = 11
