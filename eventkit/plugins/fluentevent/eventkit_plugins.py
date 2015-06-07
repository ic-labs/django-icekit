from eventkit.plugins import EventPlugin
from eventkit.plugins.fluentevent import admin, models


class FluentEventPlugin(EventPlugin):
    model = models.FluentEvent
    model_admin = admin.FluentEventAdmin
