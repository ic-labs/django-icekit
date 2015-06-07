# from django.db import models
from eventkit.models import Event
from fluent_contents.models import ContentItemRelation, PlaceholderRelation


class AbstractFluentEvent(Event):
    contentitem_set = ContentItemRelation()
    placeholder_set = PlaceholderRelation()

    class Meta:
        abstract = True


class FluentEvent(AbstractFluentEvent):
    pass
