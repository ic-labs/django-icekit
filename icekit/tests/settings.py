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
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django_nose',
    'icekit',
    'icekit.tests',
    'icekit.plugins.image',
    'icekit.plugins.slideshow',
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
