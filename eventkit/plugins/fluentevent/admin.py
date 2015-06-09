from icekit.admin import FluentLayoutsMixin

from eventkit.admin import EventChildAdmin
from eventkit.plugins.fluentevent.models import FluentEvent


class FluentEventAdmin(FluentLayoutsMixin, EventChildAdmin):
    model = FluentEvent
