from datetime import timedelta

from django.conf import settings

ICEKIT_EVENTS = getattr(settings, 'ICEKIT_EVENTS', {})

# Colors to show in admin drop-down. Users can choose other colors.
# These are fairly randomly chosen - intention is to have a bright shade
# and a dark shade, around the colour wheel, that is legible behind white text
# even at 50% opacity.
# If anyone wants to put some more thought into it, feel free to do so,
# modify the list, and remove this sentence.
EVENT_TYPE_COLOR_CHOICES = ICEKIT_EVENTS.get('EVENT_TYPE_COLOR_CHOICES', [
    # H185 S 100 V 80
    "#00BBCC", # 185
    "#0055CC", # 215
    "#1100CC", # 245
    "#7600CC", # 275
    "#CC00BB", # 305
    "#CC0054", # 335
    "#CC1100", # 5
    "#CC7700", # 35
    "#BBCC00", # 65
    # "#54CC00", # 95 # too similar
    # "#00CC10", # 125
    "#00CC77", # 155

    # H 185 S 100 V 60
    "#008C99", #185
    "#003F99", #215
    "#0C0099", #245
    "#590099", #275
    "#99008C", #305
    "#99003F", #335
    "#990C00", #5
    "#995900", #35
    "#8C9900", #65
    # "#3F9900", #95 #too similar
    # "#00990C", #125
    "#009959", #155
])

# New events will have a default `starts` value that is rounded up to a time
# matching this precision.
DEFAULT_STARTS_PRECISION = ICEKIT_EVENTS.get(
    'DEFAULT_STARTS_PRECISION', timedelta(hours=1))

# New events will have a default `ends` value that is this much later than
# their `starts` value.
DEFAULT_ENDS_DELTA = ICEKIT_EVENTS.get('DEFAULT_ENDS_DELTA', timedelta(hours=1))

# New events will have a default `date_ends` that ends on the same day.
DEFAULT_DATE_ENDS_DELTA = ICEKIT_EVENTS.get(
    'DEFAULT_DATE_ENDS_DELTA', timedelta(days=0))

# Repeat events that start later than this far in the future will not be
# created until a later date.
REPEAT_LIMIT = ICEKIT_EVENTS.get('REPEAT_LIMIT', timedelta(weeks=13))

DEFAULT_DAYS_TO_SHOW = ICEKIT_EVENTS.get('DEFAULT_DAYS_TO_SHOW', 1)
