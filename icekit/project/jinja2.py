from __future__ import absolute_import

from django.conf import settings
from django.contrib.staticfiles.storage import staticfiles_storage
from django.core.urlresolvers import reverse
from jinja2 import Environment


def environment(**options):
    """
    Add ``static`` and ``url`` functions to the environment.
    """
    env = Environment(**options)
    env.globals.update({
        'COMPRESS_ENABLED': settings.COMPRESS_ENABLED,
        'SITE_NAME': settings.SITE_NAME,
        'static': staticfiles_storage.url,
        'url': reverse,
    })
    return env
