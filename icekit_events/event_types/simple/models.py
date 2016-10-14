from icekit_events.models import Event


class SimpleEvent(Event):
    class Meta:
        verbose_name = "Simple event"
