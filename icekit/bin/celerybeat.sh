#!/bin/bash

set -e

exec celery --app=icekit.project beat --loglevel=INFO -S djcelery.schedulers.DatabaseScheduler --pidfile=
