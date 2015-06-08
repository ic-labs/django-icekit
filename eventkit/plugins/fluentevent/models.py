"""
Models for ``eventkit.plugins.fluentevent`` app.
"""

from fluent_contents.models import ContentItemRelation, PlaceholderRelation
from icekit.models import LayoutField

from eventkit.models import Event


class AbstractFluentEvent(Event):
    layout = LayoutField(default='eventkit_fluentevent/layouts/default.html')
    contentitem_set = ContentItemRelation()
    placeholder_set = PlaceholderRelation()

    class Meta:
        abstract = True


class FluentEvent(AbstractFluentEvent):
    pass
