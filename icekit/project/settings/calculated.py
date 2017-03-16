from __future__ import absolute_import, print_function

import importlib
import os
import sys

from icekit.utils.sequences import dedupe_and_sort

# Emulate `from ... import *` with base settings module from environment.
BASE_SETTINGS_MODULE = os.environ.setdefault('BASE_SETTINGS_MODULE', 'base')
print('# BASE_SETTINGS_MODULE: %s' % BASE_SETTINGS_MODULE)
try:
    locals().update(importlib.import_module(
        'icekit.project.settings._%s' % BASE_SETTINGS_MODULE).__dict__)
except ImportError:
    locals().update(importlib.import_module(BASE_SETTINGS_MODULE).__dict__)

# Create missing runtime directories.
runtime_dirs = STATICFILES_DIRS + (
    MEDIA_ROOT,
    os.path.join(PROJECT_DIR, 'templates'),
    os.path.join(VAR_DIR, 'logs'),
    os.path.join(VAR_DIR, 'run'),
    # TODO: Add layout diretories.
)
for dirname in runtime_dirs:
    try:
        os.makedirs(dirname)
    except OSError:
        pass

# Add the Python bin directory to the PATH environment variable.
SYS_PREFIX_BIN = os.path.join(sys.prefix, 'bin')
if SYS_PREFIX_BIN not in os.environ['PATH'].split(':'):
    os.environ['PATH'] = '%s:%s' % (SYS_PREFIX_BIN, os.environ['PATH'])

# DJANGO ######################################################################

AUTHENTICATION_BACKENDS = dedupe_and_sort(AUTHENTICATION_BACKENDS, [
    'master_password.auth.ModelBackend',
])

# Sort installed apps to override collect static and template load order.
INSTALLED_APPS = dedupe_and_sort(
    INSTALLED_APPS,
    [
        # First our apps.
        'icekit.dashboard',  # Must be before `icekit`
        'icekit',
        'icekit.integration.reversion',
        'polymorphic_auth',

        # Then 3rd party apps.
        'fluent_suit',
        'suit',
        'flat',
        'test_without_migrations',
    ],
)

# Sort middleware according to documentation.
MIDDLEWARE_CLASSES = dedupe_and_sort(MIDDLEWARE_CLASSES, [
    # See: http://whitenoise.evans.io/en/latest/#quickstart-for-django-apps
    'django.middleware.security.SecurityMiddleware',
    'ixc_whitenoise.WhiteNoiseMiddleware',

    # See: https://docs.djangoproject.com/en/1.8/ref/middleware/#middleware-ordering
    'django.middleware.cache.UpdateCacheMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.locale.LocaleMiddleware',
    'django.middleware.gzip.GZipMiddleware',
    'django.middleware.http.ConditionalGetMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.auth.middleware.SessionAuthenticationMiddleware',  # See: https://docs.djangoproject.com/en/1.8/ref/middleware/#django.contrib.auth.middleware.SessionAuthenticationMiddleware
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.cache.FetchFromCacheMiddleware',
    'django.contrib.flatpages.middleware.FlatpageFallbackMiddleware',
    'django.contrib.redirects.middleware.RedirectFallbackMiddleware',
])

# Get the secret key from a file that should never be committed to version
# control. If it doesn't exist, create it.
try:
    SECRET_KEY = os.environ.get('SECRET_KEY') or \
        open(SECRET_FILE).read().strip()
except IOError:
    try:
        import random
        import string
        SECRET_CHARSET = ''.join([
            string.digits, string.ascii_letters, string.punctuation])
        SECRET_KEY = ''.join(random.choice(SECRET_CHARSET) for i in range(50))
        secret = open(SECRET_FILE, 'w')
        secret.write(SECRET_KEY)
        secret.close()
        os.chmod(SECRET_FILE, 0o400)
    except IOError:
        raise Exception(
            'Please create a %s file with 50 random characters to set your '
            'secret key.' % SECRET_FILE)

# Enable template backends.
TEMPLATES = [TEMPLATES_DJANGO, TEMPLATES_JINJA2]

# COMPRESSOR ##################################################################

# Trick `compress` management command into combining files, regardless of
# `DEBUG` and `COMPRESS_ENABLED` settings.
#
# See: https://github.com/django-compressor/django-compressor/issues/258

if 'compress' in sys.argv:
    COMPRESS_ENABLED = True

# MASTER PASSWORDS ############################################################

if MASTER_PASSWORD:
    MASTER_PASSWORDS[MASTER_PASSWORD] = None

# SENTRY ######################################################################

if RAVEN_CONFIG.get('dsn'):
    INSTALLED_APPS += ('raven.contrib.django.raven_compat', )

# STORAGES ####################################################################

# Override media and thumbnail storage if S3 media is enabled
if ENABLE_S3_MEDIA:
    # "Private" S3 storage by default for most media assets
    DEFAULT_FILE_STORAGE = 'icekit.utils.storage.S3DefaultPrivateStorage'

    # "Public" S3 storage by default for thumbnails
    THUMBNAIL_DEFAULT_STORAGE = 'icekit.utils.storage.S3DefaultPublicStorage'
