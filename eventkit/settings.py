from datetime import timedelta

from django.conf import settings

EVENTKIT = getattr(settings, 'EVENTKIT', {})

# New events will have a default `starts` value that is rounded up to a time
# matching this precision.
DEFAULT_STARTS_PRECISION = EVENTKIT.get(
    'DEFAULT_STARTS_PRECISION', timedelta(hours=1))

# New events will have a default `ends` value that is this much later than
# their `starts` value.
DEFAULT_ENDS_DELTA = EVENTKIT.get('DEFAULT_ENDS_DELTA', timedelta(hours=1))

# Repeat events that start later than this far in the future will not be
# created until a later date.
REPEAT_LIMIT = EVENTKIT.get('REPEAT_LIMIT', timedelta(weeks=13))
