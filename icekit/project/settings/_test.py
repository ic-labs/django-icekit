from ._base import *

# DJANGO ######################################################################

DATABASE_NAME = 'test_%s' % DATABASES['default']['NAME']

DATABASES['default'].update({
    'NAME': DATABASE_NAME,
    'TEST': {
        'NAME': DATABASE_NAME,
        # See: https://docs.djangoproject.com/en/1.7/ref/settings/#serialize
        'SERIALIZE': False,
    },
})

INSTALLED_APPS += ('icekit.tests', )

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
