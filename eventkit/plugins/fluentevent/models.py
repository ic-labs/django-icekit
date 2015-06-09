"""
Models for ``eventkit.plugins.fluentevent`` app.
"""

from icekit.models import FluentFieldsMixin

from eventkit.models import Event


class FluentEvent(Event, FluentFieldsMixin):
    pass
