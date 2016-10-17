from icekit_events.models import EventBase


class SimpleEvent(EventBase):
    class Meta:
        verbose_name = "Simple event"
