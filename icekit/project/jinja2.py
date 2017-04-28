from __future__ import absolute_import

from django.contrib.staticfiles.storage import staticfiles_storage
from django.core.urlresolvers import reverse
from icekit.project import context_processors
from jinja2 import Environment


def environment(**options):
    """
    Add ``static`` and ``url`` functions to the ``environment`` context
    processor and return as a Jinja2 ``Environment`` object.
    """
    env = Environment(**options)
    env.globals.update({
        'static': staticfiles_storage.url,
        'url': reverse,
    })
    env.globals.update(context_processors.environment())
    return env
