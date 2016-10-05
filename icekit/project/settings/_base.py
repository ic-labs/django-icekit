"""
Safe settings by default, based on Django 1.8 project template.

Prevent accidentally leaking sensitive information, connecting to a production
database, sending live emails, etc.

Load environment specific settings via `BASE_SETTINGS_MODULE` environment
variable, and override settings in `local.py`.
"""

import hashlib
import multiprocessing
import os
import re

from django.core.urlresolvers import reverse_lazy
from django.utils.text import slugify
from kombu import Exchange, Queue

import icekit

BASE_SETTINGS_MODULE = os.environ.get('BASE_SETTINGS_MODULE', '')

# Get Redis host and port.
REDIS_ADDRESS = os.environ.get('REDIS_ADDRESS', 'localhost:6379')

# Uniquely identify the base settings module, so we can avoid conflicts with
# other projects running on the same system.
SETTINGS_MODULE_HASH = hashlib.md5(__file__ + BASE_SETTINGS_MODULE).hexdigest()

SITE_NAME = os.environ.get('SITE_NAME', 'ICEkit')
SITE_SLUG = slugify(unicode(SITE_NAME))

SITE_DOMAIN = re.sub(
    r'[^-.0-9A-Za-z]',
    '-',
    os.environ.get('SITE_DOMAIN', '%s.lvh.me' % SITE_SLUG))
SITE_PORT = 8000

# FILE SYSTEM PATHS ###########################################################

ICEKIT_DIR = os.path.abspath(os.path.dirname(icekit.__file__))
PROJECT_DIR = os.path.abspath(os.environ['ICEKIT_PROJECT_DIR'])
VAR_DIR = os.path.join(PROJECT_DIR, 'var')

# Sanity-check the ICEKIT_DIR in our settings matches the $ICEKIT_DIR
# environment variable, to ensure we are in sync with the external environment.
if ICEKIT_DIR != os.path.abspath(os.environ['ICEKIT_DIR']):
    raise Exception(
        'Mismatching paths for project setting ICEKIT_DIR and env var '
        '$ICEKIT_DIR: %s != %s' % (
            ICEKIT_DIR,
            os.path.abspath(os.environ['ICEKIT_DIR']),
        )
    )

# DJANGO CHECKLIST ############################################################

# See https://docs.djangoproject.com/en/1.8/howto/deployment/checklist/

#
# CRITICAL
#

SECRET_FILE = os.path.join(VAR_DIR, 'secret.txt')

DEBUG = False  # Don't show detailed error pages when exceptions are raised

#
# ENVIRONMENT SPECIFIC
#

# Allow connections only on the site domain.
ALLOWED_HOSTS = ('.%s' % SITE_DOMAIN, )

# Use dummy caching, so we don't get confused because a change is not taking
# effect when we expect it to.
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.dummy.DummyCache',
        'KEY_PREFIX': 'default-%s' % SETTINGS_MODULE_HASH,
    }
}

DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': os.environ.get('PGDATABASE', SITE_SLUG),
        'HOST': os.environ.get('PGHOST'),
        'PORT': os.environ.get('PGPORT'),
        'USER': os.environ.get('PGUSER'),
        'PASSWORD': os.environ.get('PGPASSWORD'),
    },
}

# EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

EMAIL_HOST = os.environ.get('EMAIL_HOST')
EMAIL_HOST_USER = os.environ.get('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_HOST_PASSWORD')
EMAIL_PORT = 587
EMAIL_USE_TLS = True

STATIC_ROOT = os.path.join(PROJECT_DIR, 'static_root')
STATIC_URL = '/static/'

MEDIA_ROOT = os.path.join(VAR_DIR, 'media_root')
MEDIA_URL = '/media/'

#
# HTTPS
#

CSRF_COOKIE_SECURE = True  # Require HTTPS for CSRF cookie
SESSION_COOKIE_SECURE = True  # Require HTTPS for session cookie

#
# PERFORMANCE
#

# Enable persistent database connections.
CONN_MAX_AGE = 60  # Default: 0

#
# ERROR REPORTING
#

# Add a root logger and change level for console handler to `DEBUG`.
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'logfile': {
            'format': (
                '%(asctime)s %(levelname)s (%(module)s.%(funcName)s) '
                '%(message)s'),
        },
    },
    'filters': {
        'require_debug_true': {
            '()': 'django.utils.log.RequireDebugTrue',
        },
    },
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'filters': ['require_debug_true'],
            'class': 'logging.StreamHandler',
        },
        'logfile': {
            'level': 'DEBUG',
            'class': 'cloghandler.ConcurrentRotatingFileHandler',
            'filename': os.path.join(
                VAR_DIR, 'logs', '%s.log' % SITE_SLUG),
            'maxBytes': 10 * 1024 * 1024,  # 10 MiB
            'backupCount': 10,
            'formatter': 'logfile',
        },
    },
    'loggers': {
        '': {
            'handlers': ['console', 'logfile'],
        },
    },
}

ADMINS = (
    ('Admin', 'admin@%s' % SITE_DOMAIN),
)
MANAGERS = ADMINS

# DJANGO ######################################################################

AUTHENTICATION_BACKENDS = (
    'django.contrib.auth.backends.ModelBackend',  # Default
)

CACHE_MIDDLEWARE_ANONYMOUS_ONLY = True

# # Enable cross-subdomain cookies, only if `SITE_DOMAIN` is not a TLD.
# if '.' in SITE_DOMAIN:
#     CSRF_COOKIE_DOMAIN = LANGUAGE_COOKIE_DOMAIN = SESSION_COOKIE_DOMAIN = \
#         '.%s' % SITE_DOMAIN

DEFAULT_FROM_EMAIL = SERVER_EMAIL = 'noreply@%s' % SITE_DOMAIN

EMAIL_SUBJECT_PREFIX = '[%s] ' % SITE_NAME

# FILE_UPLOAD_PERMISSIONS = 0755  # Default: None

# Apps that require additional configuration are enabled and configured in
# app-specific sections further below.
INSTALLED_APPS = (
    # 3rd party.
    'bootstrap3',
    'django_extensions',
    'forms_builder.forms',
    # 'ixc_redactor',
    'reversion',

    # Default.
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # Extra.
    'django.contrib.admindocs',
    'django.contrib.sitemaps',
)

LANGUAGE_CODE = 'en-au'  # Default: en-us

LOGIN_REDIRECT_URL = '/'  # Default: '/accounts/profile/'
LOGIN_URL = reverse_lazy('login')  # Default: '/accounts/signin/'
LOGOUT_URL = reverse_lazy('logout')  # Default: '/accounts/signout/'

MIDDLEWARE_CLASSES = (
    # Default.
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django.middleware.security.SecurityMiddleware',

    # Extra.
    'django.contrib.admindocs.middleware.XViewMiddleware',

    'icekit.publishing.middleware.PublishingMiddleware',
)

ROOT_URLCONF = 'icekit.project.urls'

# Fix HTTPS redirect behind proxy.
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

# Avoid session conflicts when running multiple projects on the same domain.
SESSION_COOKIE_NAME = 'sessionid-%s' % SETTINGS_MODULE_HASH

# Every write to the cache will also be written to the database. Session reads
# only use the database if the data is not already in the cache.
SESSION_ENGINE = 'django.contrib.sessions.backends.cached_db'

SILENCED_SYSTEM_CHECKS = (
    '1_6.W001',
    '1_6.W002',
)

STATICFILES_DIRS = (
    os.path.join(PROJECT_DIR, 'static'),
    os.path.join(PROJECT_DIR, 'bower_components'),
)

STATICFILES_FINDERS = (
    # Defaults.
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
)

# Define template backends separately. Backends will be added to `TEMPLATES` in
# `local.py`. This makes it easier to update for specific environments.

# Django templates backend.
TEMPLATES_DJANGO = {
    'BACKEND': 'django.template.backends.django.DjangoTemplates',
    'DIRS': [  # Default: empty
        os.path.join(PROJECT_DIR, 'templates'),
    ],
    # 'APP_DIRS': True,  # Must not be set when `loaders` is defined
    'OPTIONS': {
        'context_processors': [
            # Default.
            'django.template.context_processors.debug',
            'django.template.context_processors.request',
            'django.contrib.auth.context_processors.auth',
            'django.contrib.messages.context_processors.messages',

            # Extra.
            'django.core.context_processors.i18n',
            'django.core.context_processors.media',
            'django.core.context_processors.static',
            'django.core.context_processors.tz',

            # Project.
            'icekit.project.context_processors.environment',
        ],
        'loaders': [
            # Must come first. See:
            # https://github.com/Fantomas42/django-app-namespace-template-loader/issues/16
            'app_namespace.Loader',

            # Default.
            'django.template.loaders.filesystem.Loader',
            'django.template.loaders.app_directories.Loader',
        ],
    },
}

# Jinja2 template backend.
TEMPLATES_JINJA2 = {
    'BACKEND': 'django.template.backends.jinja2.Jinja2',
    'DIRS': [
        os.path.join(PROJECT_DIR, 'jinja2'),
    ],
    'APP_DIRS': True,
    'OPTIONS': {
        'environment': 'icekit.project.jinja2.environment',
    }
}

TIME_ZONE = 'Australia/Sydney'  # Default: America/Chicago

USE_ETAGS = True  # Default: False
# USE_I18N = False  # Default: True
USE_L10N = True  # Default: False
USE_TZ = True  # Default: False

WSGI_APPLICATION = 'icekit.project.wsgi.application'

# DJANGO REDIRECTS ############################################################

# Requires: django.contrib.sites

INSTALLED_APPS += ('django.contrib.redirects', )

MIDDLEWARE_CLASSES += (
    'django.contrib.redirects.middleware.RedirectFallbackMiddleware',
)

# DJANGO SITES ################################################################

INSTALLED_APPS += ('django.contrib.sites', )
SITE_ID = 1

# CELERY ######################################################################

BROKER_URL = CELERY_RESULT_BACKEND = 'redis://%s/0' % REDIS_ADDRESS
CELERY_ACCEPT_CONTENT = ['json', 'msgpack', 'yaml']  # 'pickle'
CELERY_DEFAULT_QUEUE = SITE_SLUG

CELERY_QUEUES = (
    Queue(
        CELERY_DEFAULT_QUEUE,
        Exchange(CELERY_DEFAULT_QUEUE),
        routing_key=CELERY_DEFAULT_QUEUE
    ),
)

CELERY_RESULT_BACKEND = 'djcelery.backends.database:DatabaseBackend'

INSTALLED_APPS += (
    'djcelery',
    'kombu.transport.django',
)

# CELERY EMAIL ################################################################

CELERY_EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
INSTALLED_APPS += ('djcelery_email', )

# COMPRESSOR ##################################################################

COMPRESS_CSS_FILTERS = (
    'compressor.filters.css_default.CssAbsoluteFilter',  # Default
    'compressor.filters.cssmin.rCSSMinFilter',
)

COMPRESS_OFFLINE = True
COMPRESS_OFFLINE_CONTEXT = 'ixc_compressor.get_compress_offline_context'

COMPRESS_PRECOMPILERS = (
    (
        'text/less',
        '%s {infile} {outfile} --autoprefix' % (
            os.path.join(PROJECT_DIR, 'node_modules', '.bin', 'lessc'),
        ),
    ),
    (
        'text/x-scss',
        '%s {infile} {outfile} --autoprefix --include-path %s' % (
            os.path.join(PROJECT_DIR, 'node_modules', '.bin', 'node-sass'),
            STATIC_ROOT,
        ),
    ),
)

INSTALLED_APPS += ('compressor', )
STATICFILES_FINDERS += ('compressor.finders.CompressorFinder', )

# Whether or not to include a fake `Request` in the global context.
# IXC_COMPRESSOR_REQUEST = False  # Default: True

# A sequence of key/value tuples to be included in every generated context.
IXC_COMPRESSOR_GLOBAL_CONTEXT = ()

# A sequence of key/value tuples, every combination of which will be combined
# with the global context when generating contexts.
IXC_COMPRESSOR_OPTIONAL_CONTEXT = ()

# DYNAMIC FIXTURES ############################################################

DDF_FILL_NULLABLE_FIELDS = False

# EASY THUMBNAILS #############################################################

INSTALLED_APPS += ('easy_thumbnails', )

# Scoped aliases allows us to pre-generate all the necessary thumbnails for a
# given model/field, without generating additional unecessary thumbnails. This
# is essential when using a remote storage backend.
THUMBNAIL_ALIASES = {
    # 'app[.model][.field]': {
    #   'name-WxH': { 'size': (W, H), },
    # },
    '': {
        'author_portrait': {
            'size': (360, 640),
        },
        'admin': {
            'size': (150, 150),
        },
        'content_image': {
            'size': (1138, 0), # maximum width of a bootstrap content column
        }
    }
}

THUMBNAIL_BASEDIR = 'thumbs'
THUMBNAIL_HIGH_RESOLUTION = True

# FLAT THEME ##################################################################

# Must come before `django.contrib.admin`.
INSTALLED_APPS += ('flat', )

# FLUENT ######################################################################

# DJANGO_WYSIWYG_FLAVOR = 'redactor'
# DJANGO_WYSIWYG_MEDIA_URL = '/'  # See redirects in `icekit.project.urls`

DJANGO_WYSIWYG_FLAVOR = 'alloyeditor'
DJANGO_WYSIWYG_MEDIA_URL = STATIC_URL + 'alloyeditor/dist/alloy-editor/'

FLUENT_CONTENTS_PLACEHOLDER_CONFIG = {
    # 'home': {
    #     'plugins': ('...', ),
    # },
    # 'main': {
    #     'plugins': ('...', ),
    # },
    # 'sidebar': {
    #     'plugins': ('...', ),
    # },
}

FLUENT_DASHBOARD_DEFAULT_MODULE = 'ModelList'

FLUENT_MARKUP_LANGUAGES = ('restructuredtext', 'markdown', 'textile')
FLUENT_MARKUP_MARKDOWN_EXTRAS = ()

FLUENT_PAGES_PARENT_ADMIN_MIXIN = \
    'icekit.publishing.admin.ICEKitFluentPagesParentAdminMixin'

# Avoid an exception because fluent-pages wants `TEMPLATE_DIRS[0]` to be
# defined, even though that setting is going away. This might not be necessary
# in more recent versions of fluent-pages.
FLUENT_PAGES_TEMPLATE_DIR = TEMPLATES_DJANGO['DIRS'][0]
# os.path.join(PROJECT_DIR, 'layouts', 'templates')

# FLUENT_TEXT_CLEAN_HTML = True  # Default: False
# FLUENT_TEXT_SANITIZE_HTML = True  # Default: False

INSTALLED_APPS += (
    'fluent_contents',
    'fluent_pages',

    # Dependencies.
    'mptt',
    'parler',
    'polymorphic',
    'polymorphic_tree',

    # Page types.
    # 'fluent_pages.pagetypes.flatpage',
    # 'fluent_pages.pagetypes.fluentpage',
    'fluent_pages.pagetypes.redirectnode',

    # Content plugins.
    # 'fluent_contents.plugins.code',
    # 'fluent_contents.plugins.commentsarea',
    # 'fluent_contents.plugins.disquswidgets',
    # 'fluent_contents.plugins.formdesignerlink',
    # 'fluent_contents.plugins.gist',
    # 'fluent_contents.plugins.googledocsviewer',
    'fluent_contents.plugins.iframe',
    # 'fluent_contents.plugins.markup',
    'fluent_contents.plugins.oembeditem',
    'fluent_contents.plugins.picture',
    'fluent_contents.plugins.rawhtml',
    'fluent_contents.plugins.sharedcontent',
    'fluent_contents.plugins.text',
    # 'fluent_contents.plugins.twitterfeed',

    # Page type and content plugin dependencies.
    # 'any_urlfield',
    'django_wysiwyg',
    'micawber',
)

# GUARDIAN ####################################################################

# INSTALLED_APPS += ('guardian', )
# AUTHENTICATION_BACKENDS += ('guardian.backends.ObjectPermissionBackend', )

# HAYSTACK ####################################################################

HAYSTACK_CONNECTIONS = {
    'default': {
        'ENGINE': 'elasticstack.backends.ConfigurableElasticSearchEngine',
        'INDEX_NAME': 'haystack-%s' % SETTINGS_MODULE_HASH,
        'URL': 'http://localhost:9200/',
    },
}

HAYSTACK_SIGNAL_PROCESSOR = 'haystack.signals.BaseSignalProcessor'
INSTALLED_APPS += ('haystack', )

# HOSTS #######################################################################

# INSTALLED_APPS += ('django_hosts', )
# MIDDLEWARE_CLASSES += ('django_hosts.middleware.HostsMiddleware', )

# DEFAULT_HOST = 'www'
# ROOT_HOSTCONF = 'icekit.hosts'

# ICEKIT ######################################################################

FEATURED_APPS = (
    {
        'verbose_name': 'Content',
        'icon_html': '<i class="content-type-icon fa fa-files-o"></i>',
        'models': {
            'fluent_pages.Page': {
                'verbose_name_plural': 'Pages',
            },
        },
    },
    {
        'verbose_name': 'Media',
        'icon_html': '<i class="content-type-icon fa fa-file-image-o"></i>',
        'models': {
            'image.Image': {},
            'slideshow.Slideshow': {},
            'sharedcontent.SharedContent': {},
        },
    },
)

ICEKIT = {
    'LAYOUT_TEMPLATES': (
        (
            'ICEkit',
            os.path.join(ICEKIT_DIR, 'layouts/templates'),
            'icekit/layouts',
        ),
        (
            SITE_NAME,
            os.path.join(PROJECT_DIR, 'templates'),
            'layouts',
        ),
    ),
}

INSTALLED_APPS += (
    'icekit',
    'icekit.dashboard',  # Must come before `django.contrib.admin` and `flat`
    'icekit.integration.reversion',
    'icekit.layouts',
    'icekit.publishing',
    'icekit.response_pages',
    'notifications',

    'icekit.authors',
    'icekit.page_types.layout_page',
    'icekit.page_types.search_page',

    # 'icekit.plugins.brightcove',
    'icekit.plugins.child_pages',
    'icekit.plugins.faq',
    'icekit.plugins.file',
    'icekit.plugins.horizontal_rule',
    'icekit.plugins.image',
    'icekit.plugins.instagram_embed',
    'icekit.plugins.map',
    'icekit.plugins.map_with_text',
    'icekit.plugins.oembed_with_caption',
    'icekit.plugins.page_anchor',
    'icekit.plugins.page_anchor_list',
    'icekit.plugins.quote',
    'icekit.plugins.reusable_form',
    'icekit.plugins.slideshow',
    'icekit.plugins.twitter_embed',
)

# MASTER PASSWORD #############################################################

AUTHENTICATION_BACKENDS += ('master_password.auth.ModelBackend', )

INSTALLED_APPS += ('master_password', )
MASTER_PASSWORD = os.environ.get('MASTER_PASSWORD')
MASTER_PASSWORDS = {}

# MODEL SETTINGS ##############################################################

INSTALLED_APPS += ('model_settings', 'polymorphic')

TEMPLATES_DJANGO['OPTIONS']['context_processors'].append(
    'model_settings.context_processors.settings')

# NEW RELIC ###################################################################

# os.environ.setdefault('NEW_RELIC_CONFIG_FILE', 'newrelic.ini')
# os.environ.setdefault('NEW_RELIC_ENVIRONMENT', BASE_SETTINGS_MODULE)

# NOSE ########################################################################

INSTALLED_APPS += ('django_nose', )
TEST_RUNNER = 'django_nose.NoseTestSuiteRunner'  # Default: django.test.runner.DiscoverRunner

NOSE_ARGS = [
    '--logging-clear-handlers',  # Clear all other logging handlers
    '--nocapture',  # Don't capture stdout
    '--nologcapture',  # Disable logging capture plugin
    # '--processes=-1',  # Automatically set to the number of cores
    '--with-progressive',  # See https://github.com/erikrose/nose-progressive
]

# POLYMORPHIC AUTH ############################################################

AUTH_USER_MODEL = 'polymorphic_auth.User'

INSTALLED_APPS += (
    'polymorphic',
    'polymorphic_auth',
    'polymorphic_auth.usertypes.email',
    # 'polymorphic_auth.usertypes.username',
)

POLYMORPHIC_AUTH = {
    'DEFAULT_CHILD_MODEL': 'polymorphic_auth_email.EmailUser',
    # 'DEFAULT_CHILD_MODEL': 'polymorphic_auth_username.UsernameUser',
}

# POST OFFICE #################################################################

EMAIL_BACKEND = 'post_office.EmailBackend'
INSTALLED_APPS += ('post_office', )

POST_OFFICE = {
    'BACKENDS': {
        'default': 'djcelery_email.backends.CeleryEmailBackend',
    },
    'DEFAULT_PRIORITY': 'now',
}

# SENTRY ######################################################################

RAVEN_CONFIG = {
    'dsn': os.environ.get('SENTRY_DSN'),
}

# STORAGES ####################################################################

AWS_ACCESS_KEY_ID = os.environ.get('MEDIA_AWS_ACCESS_KEY_ID')

# See: http://developer.yahoo.com/performance/rules.html#expires
AWS_HEADERS = {
    'Expires': 'Thu, 31 Dec 2099 00:00:00 GMT',
    'Cache-Control': 'max-age=86400',
}

AWS_SECRET_ACCESS_KEY = os.environ.get('MEDIA_AWS_SECRET_ACCESS_KEY')

AWS_STORAGE_BUCKET_NAME = os.environ.get(
    'MEDIA_AWS_STORAGE_BUCKET_NAME', '%s-stg' % SITE_SLUG)

ENABLE_S3_MEDIA = False
INSTALLED_APPS += ('storages', )

# SUIT ########################################################################

# INSTALLED_APPS += (
#     'fluent_suit',
#     'suit',
# )

# TEST WITHOUT MIGRATIONS #####################################################

INSTALLED_APPS += ('test_without_migrations', )

# Default: django.core.management.commands.test.Command
TEST_WITHOUT_MIGRATIONS_COMMAND = \
    'django_nose.management.commands.test.Command'

# WHITENOISE ##################################################################

# DEFAULT_FILE_STORAGE = 'ixc_whitenoise.HashedMediaStorage'
STATICFILES_STORAGE = 'ixc_whitenoise.CompressedManifestStaticFilesStorage'

IXC_WHITENOISE_HASHED_MEDIA_ORIGINAL_PREFIX = False

MIDDLEWARE_CLASSES += ('ixc_whitenoise.WhiteNoiseMiddleware', )

WHITENOISE_AUTOREFRESH = True
WHITENOISE_USE_FINDERS = True

WHITENOISE_ROOT = os.path.join(PROJECT_DIR, 'whitenoise_root')

# WSGI ########################################################################

WSGI_ADDRESS = '127.0.0.1'
WSGI_PORT = 8080
WSGI_TIMEOUT = 60
WSGI_WORKERS = multiprocessing.cpu_count() * 2 + 1
