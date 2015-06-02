from datetime import timedelta

from django.conf import settings

EVENTKIT = getattr(settings, 'EVENTKIT', {})

# Background and text colors for calendar view. Defaults are based on the
# Base16 color scheme. See: https://github.com/chriskempson/base16
CALENDAR_COLORS = EVENTKIT.get('CALENDAR_COLOURS', [
    ('#ab4642', '#f8f8f8'),
    ('#dc9656', '#f8f8f8'),
    ('#f7ca88', '#f8f8f8'),
    ('#a1b56c', '#f8f8f8'),
    ('#86c1b9', '#f8f8f8'),
    ('#7cafc2', '#f8f8f8'),
    ('#ba8baf', '#f8f8f8'),
    ('#a16946', '#f8f8f8'),
])

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
