from icekit_events.models import AbstractEventWithLayouts
from icekit.mixins import ListableMixin, HeroMixin


class SimpleEvent(
    AbstractEventWithLayouts,
    ListableMixin,
    HeroMixin
):
    class Meta:
        verbose_name = "Simple event"
