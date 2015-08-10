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
    'forms_builder.forms',
    'fluent_contents',
    'fluent_pages',
    'fluent_pages.pagetypes.fluentpage',
    'haystack',
    'icekit',
    'icekit.page_types.layout_page',
    'icekit.page_types.search_page',
    'icekit.plugins.child_pages',
    'icekit.plugins.faq',
    'icekit.plugins.image',
    'icekit.plugins.instagram_embed',
    'icekit.plugins.map',
    'icekit.plugins.map_with_text',
    'icekit.plugins.page_anchor',
    'icekit.plugins.page_anchor_list',
    'icekit.plugins.quote',
    'icekit.plugins.reusable_quote',
    'icekit.plugins.reusable_form',
    'icekit.plugins.slideshow',
    'icekit.plugins.twitter_embed',
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
TEST_RUNNER = 'django.test.runner.DiscoverRunner'


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

HAYSTACK_CONNECTIONS = {
    'default': {
        'ENGINE': 'haystack.backends.simple_backend.SimpleEngine',
    },
}
