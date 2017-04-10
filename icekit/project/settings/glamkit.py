from .icekit import *

# DJANGO ######################################################################

INSTALLED_APPS += (
    'sponsors',
    'press_releases',
    'icekit.api',
    'icekit.plugins.iiif',

    'icekit_events',
    'icekit_events.event_types.simple',
    'icekit_events.plugins.event_content_listing',
    'icekit_events.plugins.links',
    'icekit_events.plugins.todays_occurrences',
    'icekit_events.page_types.eventlistingfordate',

    'adminsortable2',  # required by glamkit-collections

    # GLAMkit Collection base implementation plugins
    'glamkit_collections.contrib.work_creator',
    'glamkit_collections.contrib.work_creator.plugins.artwork',
    'glamkit_collections.contrib.work_creator.plugins.film',
    'glamkit_collections.contrib.work_creator.plugins.game',
    'glamkit_collections.contrib.work_creator.plugins.links',
    'glamkit_collections.contrib.work_creator.plugins.moving_image',
    'glamkit_collections.contrib.work_creator.plugins.organization',
    'glamkit_collections.contrib.work_creator.plugins.person',

    # Django REST framework for APIs
    'rest_framework',
    'rest_framework.authtoken',  # Required for `TokenAuthentication`
    'rest_framework_swagger',  # Required for automatic API documentation
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


REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        # Enable session authentication for simple access via web browser and
        # for AJAX requests, see
        # http://www.django-rest-framework.org/api-guide/authentication/#sessionauthentication
        'rest_framework.authentication.SessionAuthentication',
        # Enable token authentication for access by clients such as bots
        # outside a web browser context, see
        # http://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication
        'rest_framework.authentication.TokenAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        # Apply Django's standard model permissions for API operations, with
        # customisation to prevent any API access for GET listings, HEAD etc
        # to those users permitted to view model listings in the admin. See
        # http://www.django-rest-framework.org/api-guide/permissions/#djangomodelpermissions
        'icekit.utils.api.DjangoModelPermissionsRestrictedListing',
    ),
    'DEFAULT_FILTER_BACKENDS': (
        'rest_framework_filters.backends.DjangoFilterBackend',
        'rest_framework.filters.OrderingFilter',
    ),
    # Pagination settings
    'DEFAULT_PAGINATION_CLASS':
        'icekit.api.pagination.DefaultPageNumberPagination',
    'PAGE_SIZE': 20,
}


# REST Swagger/OpenAPI Documentation via Django REST Swagger

SWAGGER_SETTINGS = {
    # 'doc_expansion': 'full',
    'version': '0.1',
    'api_path': "/api/",
    'enabled_methods': ['get'],
    'info': {
        "title": "GLAMkit API",
        "description": "GLAMkit API for Pages, Images, Artists, and Artworks",
        # "termsOfServiceUrl": "http://helloreverb.com/terms/",
        # "contact": "apiteam@wordnik.com",
        # "license": "Apache 2.0",
        # "licenseUrl": "http://www.apache.org/licenses/LICENSE-2.0.html"
    },
}
