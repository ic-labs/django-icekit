from ._base import *

# DJANGO ######################################################################

ALLOWED_HOSTS = ('*', )

CSRF_COOKIE_SECURE = False  # Don't require HTTPS for CSRF cookie
SESSION_COOKIE_SECURE = False  # Don't require HTTPS for session cookie

DATABASES['default'].update({
    'TEST': {
        'NAME': DATABASES['default']['NAME'],
        # See: https://docs.djangoproject.com/en/1.7/ref/settings/#serialize
        'SERIALIZE': False,
    },
})

INSTALLED_APPS += (
    'fluent_pages.pagetypes.fluentpage',
    'icekit.tests',
)

ROOT_URLCONF = 'icekit.tests.urls'

TEMPLATES_DJANGO['DIRS'].insert(
    0, os.path.join(BASE_DIR, 'icekit', 'tests', 'templates')),

# ICEKIT ######################################################################

# RESPONSE_PAGE_PLUGINS = ['ImagePlugin', ]

# HAYSTACK ####################################################################

# HAYSTACK_CONNECTIONS = {
#     'default': {
#         'ENGINE': 'haystack.backends.simple_backend.SimpleEngine',
#     },
# }

# TRAVIS ######################################################################

if 'TRAVIS' in os.environ:
    NOSE_ARGS.remove('--with-progressive')
