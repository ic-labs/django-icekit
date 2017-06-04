from django.db import models
from icekit.plugins.links.abstract_models import AbstractLinkItem


class EventLink(AbstractLinkItem):
    item = models.ForeignKey("icekit_events.EventBase", on_delete=models.CASCADE)

    include_even_when_finished = models.BooleanField(
        help_text="Show this link even when the event has finished.",
        default=False
    )

    class Meta:
        verbose_name = "Event link"
