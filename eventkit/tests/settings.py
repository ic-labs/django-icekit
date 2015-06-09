"""
Test settings for ``eventkit`` app.
"""

import os

BASE_DIR = os.path.dirname(__file__)

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
}

DEBUG = True
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django_nose',
    'icekit',
    'eventkit',
    'eventkit.tests',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
)

ROOT_URLCONF = 'eventkit.tests.urls'
SECRET_KEY = 'secret-key'
STATIC_URL = '/static/'
TEST_RUNNER = 'django_nose.NoseTestSuiteRunner'  # Default: django.test.runner.DiscoverRunner
TIME_ZONE = 'Australia/Sydney'  # Default: America/Chicago
USE_TZ = True  # Default: False

DDF_FILL_NULLABLE_FIELDS = False
FLUENT_PAGES_TEMPLATE_DIR = os.path.join(BASE_DIR, '..', 'templates')
