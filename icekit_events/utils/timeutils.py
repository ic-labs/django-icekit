from datetime import datetime, timedelta, time
from timezone import timezone as djtz  # django-timezone
from django.conf import settings
from django.utils.timezone import is_aware, is_naive, make_naive, make_aware, \
    get_current_timezone


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
    when = when or djtz.now()
    weekday = WEEKDAYS.get(precision, WEEKDAYS['MON'])
    if precision in WEEKDAYS:
        precision = int(timedelta(days=7).total_seconds())
    elif isinstance(precision, timedelta):
        precision = int(precision.total_seconds())
    # Get delta between the beginning of time and the given datetime object.
    # If precision is a weekday, the beginning of time must be that same day.
    when_min = when.min + timedelta(days=weekday)
    if djtz.is_aware(when):
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


def zero_datetime(dt, tz=None):
    """
    Return the given datetime with hour/minutes/seconds/ms zeroed and the
    timezone coerced to the given ``tz`` (or UTC if none is given).
    """
    if tz is None:
        tz = get_current_timezone()
    return coerce_naive(dt).replace(hour=0, minute=0, second=0, microsecond=0)


def coerce_dt_awareness(date_or_datetime, tz=None, t=None):
    """
    Coerce the given `datetime` or `date` object into a timezone-aware or
    timezone-naive `datetime` result, depending on which is appropriate for
    the project's settings.
    """
    if isinstance(date_or_datetime, datetime):
        dt = date_or_datetime
    else:
        dt = datetime.combine(date_or_datetime, t or time.min)
    is_project_tz_aware = settings.USE_TZ
    if is_project_tz_aware:
        return coerce_aware(dt, tz)
    elif not is_project_tz_aware:
        return coerce_naive(dt, tz)
    # No changes necessary
    return dt


def coerce_naive(dt, tz=None):
    if is_naive(dt):
        return dt
    else:
        if tz is None:
            tz = get_current_timezone()
        return make_naive(dt, tz)


def coerce_aware(dt, tz=None):
    if is_aware(dt):
        return dt
    else:
        if tz is None:
            tz = get_current_timezone()
        return make_aware(dt, tz)


def format_naive_ical_dt(date_or_datetime):
    """
    Return datetime formatted for use in iCal as a *naive* datetime value to
    work more like people expect, e.g. creating a series of events starting
    at 9am should not create some occurrences that start at 8am or 10am after
    a daylight savings change.
    """
    dt = coerce_dt_awareness(date_or_datetime)
    if is_naive(dt):
        return dt.strftime('%Y%m%dT%H%M%S')
    else:
        return dt.astimezone(get_current_timezone()).strftime('%Y%m%dT%H%M%S')


def localize_preserving_time_of_day(dt):
    """
    Return the given datetime with the same time-of-day (hours and minutes) as
    it *seems* to have, even if it has been adjusted by applying `timedelta`
    additions that traverse daylight savings dates and would therefore
    otherwise trigger changes to its apparent time.
    """
    # Remember the apparent time-of-day hours and minutes
    hour, minute = dt.hour, dt.minute
    # Ensure we have a localized datetime, which will trigger any hour/minute
    # changes depending on daylight saving changes triggered by a timedelta
    # operation
    dt_localized = djtz.localize(dt)
    # Forcibly reset the hour and minute time-of-day values to the apparent
    # values we stored
    return dt_localized.replace(hour=hour, minute=minute)
