from eventkit.plugins import EventPlugin
from eventkit.plugins.exhibition import admin, models


class FluentEventPlugin(EventPlugin):
    model = models.Exhibition
    model_admin = admin.ExhibitionAdmin
