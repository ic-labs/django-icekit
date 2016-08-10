from ._base import *

# DJANGO ######################################################################

ALLOWED_HOSTS = ('*', )

CSRF_COOKIE_SECURE = False  # Don't require HTTPS for CSRF cookie
SESSION_COOKIE_SECURE = False  # Don't require HTTPS for session cookie

DEBUG = True  # Show detailed error pages when exceptions are raised

# WSGI ##################################################################

WSGI_WORKERS = 2  # Default: 2x CPU cores + 1
