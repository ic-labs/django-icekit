from django.db import models
from icekit.plugins.links.abstract_models import AbstractLinkItem


class EventLink(AbstractLinkItem):
    item = models.ForeignKey("icekit_events.EventBase")

    class Meta:
        verbose_name = "Event link"
