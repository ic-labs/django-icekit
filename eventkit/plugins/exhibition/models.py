"""
Models for ``eventkit.plugins.exhibition`` app.
"""

from django.db import models
from icekit.models import FluentFieldsMixin

from eventkit.models import Event


class Exhibition(Event, FluentFieldsMixin):
    events = models.ManyToManyField(
        'eventkit.Event',
        blank=True,
        help_text='Events that belong to this exhibition.',
        related_name='exhibitions',
    )
