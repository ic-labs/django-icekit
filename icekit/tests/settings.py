"""
Test settings for ``icekit`` app.
"""
import os

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
}

SITE_ID = 1

DEBUG = True
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

INSTALLED_APPS = (
    'bootstrap3',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django_nose',
    'fluent_contents',
    'fluent_pages',
    'fluent_pages.pagetypes.fluentpage',
    'icekit',
    'icekit.plugins.faq',
    'icekit.plugins.image',
    'icekit.plugins.quote',
    'icekit.plugins.reusable_quote',
    'icekit.plugins.slideshow',
    'icekit.response_pages',
    'icekit.tests',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
)

ROOT_URLCONF = 'icekit.tests.urls'
SECRET_KEY = 'secret-key'
STATIC_URL = '/static/'
# TEST_RUNNER = 'django_nose.NoseTestSuiteRunner'


BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
FLUENT_PAGES_TEMPLATE_DIR = os.path.join(
    BASE_DIR, 'icekit', 'templates',
)

BRIGHTCOVE_PLAYER = {}
BRIGHTCOVE_TOKEN = ''

RESPONSE_PAGE_PLUGINS = ['ImagePlugin', ]

TEMPLATE_CONTEXT_PROCESSORS = [
    'django.core.context_processors.debug',
    'django.core.context_processors.request',
    'django.contrib.auth.context_processors.auth',
    'django.contrib.messages.context_processors.messages',
]
