from __future__ import absolute_import

import os

from celery import Celery

# set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'icekit.project.settings')

from django.conf import settings  # noqa

app = Celery('icekit')

# Using a string here means the worker will not have to
# pickle the object when using Windows.
app.config_from_object('django.conf:settings')
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)

# Sentry/raven integration for celery - placed after the celery initialisation
# so that Raven is capable of wiring into the project's celery app
from raven.contrib.django.raven_compat.models import client
from raven.contrib.celery import register_signal, register_logger_signal

# Register a custom filter to filter out duplicate logs
register_logger_signal(client)
# Hook into the Celery error handler
register_signal(client)
