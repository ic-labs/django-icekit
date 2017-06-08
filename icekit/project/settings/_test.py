from ._base import *

# DJANGO ######################################################################

ALLOWED_HOSTS = ('*', )
CACHES['default'].update({'BACKEND': 'redis_lock.django_cache.RedisCache'})

CSRF_COOKIE_SECURE = False  # Don't require HTTPS for CSRF cookie
SESSION_COOKIE_SECURE = False  # Don't require HTTPS for session cookie

_DATABASE_NAME = 'test_' + DATABASES['default']['NAME']

DATABASES['default'].update({
    'NAME': _DATABASE_NAME,
    'TEST': {
        'NAME': _DATABASE_NAME,
        # See: https://docs.djangoproject.com/en/1.7/ref/settings/#serialize
        'SERIALIZE': False,
    },
})

INSTALLED_APPS += (
    'fluent_pages.pagetypes.fluentpage',
    'icekit.tests',
    'icekit_events.tests',
)

ROOT_URLCONF = 'icekit.tests.urls'

TEMPLATES_DJANGO['DIRS'].insert(
    0, os.path.join(ICEKIT_DIR, 'tests', 'templates')),

EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
TIME_ZONE = 'Australia/Sydney'  # Default: America/Chicago

DDF_FILL_NULLABLE_FIELDS = False
DDF_IGNORE_FIELDS = ['*_ptr']  # Ignore django-polymorphic pointer fields

DEBUG = True

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

# Unconfigure django-hosts
INSTALLED_APPS = tuple([
    app for app in INSTALLED_APPS if app != 'django_hosts'
])
MIDDLEWARE_CLASSES = tuple([
    classname for classname in MIDDLEWARE_CLASSES
    if 'django_hosts' not in classname
])
