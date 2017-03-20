from collections import OrderedDict

from .icekit import *

# DJANGO ######################################################################

INSTALLED_APPS += (
    'sponsors',
    'press_releases',
    'icekit.plugins.iiif',

    'icekit_events',
    'icekit_events.event_types.simple',
    'icekit_events.plugins.event_content_listing',
    'icekit_events.plugins.links',
    'icekit_events.plugins.todays_occurrences',
    'icekit_events.page_types.eventlistingfordate',
)

# This settings file is loaded after calculated.py, so we don't want to
# overwrite the urlconf if it is set to the test urls.
if not 'test' in ROOT_URLCONF:
    ROOT_URLCONF = "icekit.project.glamkit_urls"

# ICEKIT PRESS RELEASES #######################################################

ICEKIT['DASHBOARD_FEATURED_APPS'][0]['models'] += [
    ('icekit_press_releases.PressRelease', {})
]

# ICEKIT EVENTS ###############################################################

ICEKIT['DASHBOARD_FEATURED_APPS'] = [
    {
        'name': 'Events',
        'icon_html': '<i class="content-type-icon fa fa-calendar-o"></i>',
        'models': [
            ('icekit_events.EventBase', {})
        ],
    },
    {
        'name': 'Collection',
        'icon_html': '<i class="content-type-icon fa fa-diamond"></i>',
        'models': [
            ('gk_collections_work_creator.WorkBase', {}),
            ('gk_collections_work_creator.CreatorBase', {}),
        ],
    },
] + ICEKIT['DASHBOARD_FEATURED_APPS']

ICEKIT['DASHBOARD_FEATURED_APPS'][3]['models'] += [('glamkit_sponsors.Sponsor', {})]

# GLAMKIT SPONSORS ############################################################
SPONSOR_PLUGINS = [
    'BeginSponsorBlockPlugin',
    'EndSponsorBlockPlugin',
    'SponsorPromoPlugin',
]

LINK_PLUGINS += [
    'EventLinkPlugin',
    'TodaysOccurrencesPlugin',
]

DEFAULT_PLUGINS += \
    SPONSOR_PLUGINS + LINK_PLUGINS + ['EventContentListingPlugin']


# CONFIGURE PLACEHOLDERS ######################################################

FLUENT_CONTENTS_PLACEHOLDER_CONFIG.update({
    'main': {'plugins': DEFAULT_PLUGINS },
    'pressrelease_contacts': {
        'plugins': (
            'ContactPersonPlugin',
            'TextPlugin',
        ),
    },
    'related': {'plugins': LINK_PLUGINS },
})
