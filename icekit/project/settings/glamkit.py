from .icekit import *

# DJANGO ######################################################################

INSTALLED_APPS += (
    'sponsors',

    'icekit_events',
    'icekit_events.event_types.simple',
    'icekit_events.page_types.eventlistingfordate',
)

ROOT_URLCONF = "icekit.project.glamkit_urls"
