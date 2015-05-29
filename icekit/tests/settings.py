"""
Test settings for ``icekit`` app.
"""
import os

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': 'db.sqlite3',
    }
}

SITE_ID = 1

DEBUG = True
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django_brightcove',
    'django_nose',
    'icekit',
    'icekit.tests',
    'icekit.plugins.brightcove',
    'icekit.plugins.image',
    'fluent_contents',
    'fluent_pages',
    'bootstrap3',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
)

ROOT_URLCONF = 'icekit.urls'
SECRET_KEY = 'secret-key'
STATIC_URL = '/static/'
TEST_RUNNER = 'django_nose.NoseTestSuiteRunner'


BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
FLUENT_PAGES_TEMPLATE_DIR = os.path.join(
    BASE_DIR, 'icekit', 'templates',
)


# BRIGHTCOVE ##################################################################
BRIGHTCOVE_TOKEN = ''
BRIGHTCOVE_PLAYER = {
    'default': {
        'PLAYERID': 'a_default_player_id',
        'PLAYERKEY': 'a_default_player_key',
    },
    'single': {
        'PLAYERID': 'another_player_id',
        'PLAYERKEY': 'another_player_key',
    },
}
