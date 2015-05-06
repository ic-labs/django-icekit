try:
    from django.db import migrations
except ImportError:
    from django.core.exceptions import ImproperlyConfigured
    raise ImproperlyConfigured(
        'These migrations are for use with Django 1.7 and above. For Django '
        '1.6 and below, upgrade to South 1.0.')
