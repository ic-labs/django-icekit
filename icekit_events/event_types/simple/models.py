from icekit_events.models import AbstractEventWithLayouts


class SimpleEvent(AbstractEventWithLayouts):
    class Meta:
        verbose_name = "Simple event"
