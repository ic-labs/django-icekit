"""
Models for ``eventkit.plugins.fluentevent`` app.
"""

from django.db import models
from fluent_contents.models import ContentItemRelation, PlaceholderRelation

from eventkit.models import Event


class AbstractFluentEvent(Event):
    layout = models.ForeignKey('icekit.Layout', blank=True, null=True)

    contentitem_set = ContentItemRelation()
    placeholder_set = PlaceholderRelation()

    class Meta:
        abstract = True


class FluentEvent(AbstractFluentEvent):
    pass
