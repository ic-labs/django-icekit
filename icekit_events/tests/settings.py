"""
Test settings for ``icekit_events`` app.
"""

import os

BASE_DIR = os.path.dirname(__file__)

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'test_icekit_events',
        'ATOMIC_REQUESTS': True,
        'TEST': {
            'NAME': 'test_icekit_events',
            # See: https://docs.djangoproject.com/en/1.7/ref/settings/#serialize
            'SERIALIZE': False,
        },
    }
}

DEBUG = True
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

SITE_DOMAIN = SITE_NAME = 'localhost'
SITE_PORT = '8080'
SITE_ID = 1

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django_nose',
    'icekit',
    'icekit_events',
    'icekit_events.tests',

    # Apps required for publishing features
    'icekit.publishing',
    'model_settings',
    'polymorphic',
    'compressor',

    # Test ICEKit pages etc
    'django.contrib.sites',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'icekit.publishing.middleware.PublishingMiddleware',
)

ROOT_URLCONF = 'icekit_events.tests.urls'
SECRET_KEY = 'secret-key'
STATIC_URL = '/static/'
TEST_RUNNER = 'django_nose.NoseTestSuiteRunner'  # Default: django.test.runner.DiscoverRunner
TIME_ZONE = 'Australia/Sydney'  # Default: America/Chicago
USE_TZ = True  # Default: False
STATIC_ROOT = os.path.join(BASE_DIR, 'static')

DDF_FILL_NULLABLE_FIELDS = False
FLUENT_PAGES_TEMPLATE_DIR = os.path.join(BASE_DIR, '..', 'templates')
