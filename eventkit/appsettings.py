from datetime import timedelta

from django.conf import settings

EVENTKIT = getattr(settings, 'EVENTKIT', {})

# Background and text colors for calendar view. Defaults are based on the
# Base16 `ashes` color scheme. See: https://github.com/chriskempson/base16
CALENDAR_COLORS = EVENTKIT.get('CALENDAR_COLOURS', [
    ('#aec795', '#f3f4f5'),
    ('#95c7ae', '#f3f4f5'),
    ('#95aec7', '#f3f4f5'),
    ('#ae95c7', '#f3f4f5'),
    ('#c795ae', '#f3f4f5'),
    ('#c79595', '#f3f4f5'),
    ('#c7ae95', '#f3f4f5'),
    ('#c7c795', '#f3f4f5'),
])

# New events will have a default `starts` value that is rounded up to a time
# matching this precision.
DEFAULT_STARTS_PRECISION = EVENTKIT.get(
    'DEFAULT_STARTS_PRECISION', timedelta(hours=1))

# New events will have a default `ends` value that is this much later than
# their `starts` value.
DEFAULT_ENDS_DELTA = EVENTKIT.get('DEFAULT_ENDS_DELTA', timedelta(hours=1))

# New events will have a default `date_ends` that ends on the same day.
DEFAULT_DATE_ENDS_DELTA = EVENTKIT.get(
    'DEFAULT_DATE_ENDS_DELTA', timedelta(days=0))

# Repeat events that start later than this far in the future will not be
# created until a later date.
REPEAT_LIMIT = EVENTKIT.get('REPEAT_LIMIT', timedelta(weeks=13))
