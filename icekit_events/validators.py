"""
Validators for ``icekit_events`` app.
"""

from dateutil import rrule

from django.core.exceptions import ValidationError
from django.utils.translation import ugettext_lazy as _


def recurrence_rule(value):
    """
    Validate that a ``rruleset`` object can be creted from ``value``.
    """
    try:
        rrule.rrulestr(value)
    except ValueError:
        raise ValidationError(
            _('Enter a valid iCalendar (RFC2445) recurrence rule.'),
            code='invalid')
