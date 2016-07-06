from datetime import datetime, timedelta

from timezone import timezone

ROUND_DOWN = 'ROUND_DOWN'
ROUND_NEAREST = 'ROUND_NEAREST'
ROUND_UP = 'ROUND_UP'

WEEKDAYS = {
    'MON': 0,
    'TUE': 1,
    'WED': 2,
    'THU': 3,
    'FRI': 4,
    'SAT': 5,
    'SUN': 6,
}

MON = 'MON'
TUE = 'TUE'
WED = 'WED'
THU = 'THU'
FRI = 'FRI'
SAT = 'SAT'
SUN = 'SUN'


def round_datetime(when=None, precision=60, rounding=ROUND_NEAREST):
    """
    Round a datetime object to a time that matches the given precision.

        when (datetime), default now
            The datetime object to be rounded.

        precision (int, timedelta, str), default 60
            The number of seconds, weekday (MON, TUE, WED, etc.) or timedelta
            object to which the datetime object should be rounded.

        rounding (str), default ROUND_NEAREST
            The rounding method to use (ROUND_DOWN, ROUND_NEAREST, ROUND_UP).

    """
    when = when or timezone.now()
    weekday = WEEKDAYS.get(precision, WEEKDAYS['MON'])
    if precision in WEEKDAYS:
        precision = int(timedelta(days=7).total_seconds())
    elif isinstance(precision, timedelta):
        precision = int(precision.total_seconds())
    # Get delta between the beginning of time and the given datetime object.
    # If precision is a weekday, the beginning of time must be that same day.
    when_min = when.min + timedelta(days=weekday)
    if timezone.is_aware(when):
        # It doesn't seem to be possible to localise `datetime.min` without
        # raising `OverflowError`, so create a timezone aware object manually.
        when_min = datetime(tzinfo=when.tzinfo, *when_min.timetuple()[:3])
    delta = when - when_min
    remainder = int(delta.total_seconds()) % precision
    # First round down and strip microseconds.
    when -= timedelta(seconds=remainder, microseconds=when.microsecond)
    # Then add precision to round up.
    if rounding == ROUND_UP or (
            rounding == ROUND_NEAREST and remainder >= precision / 2):
        when += timedelta(seconds=precision)
    return when
