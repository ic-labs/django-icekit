#!/bin/bash

set -e

# See: http://docs.gunicorn.org/en/stable/design.html#how-many-workers
let "GUNICORN_WORKERS = ${GUNICORN_WORKERS:-${CPU_CORES:-1} * 2 + 1}"

if [[ -n "${NEW_RELIC_ENVIRONMENT+1}" ]]; then
	exec newrelic-admin run-program gunicorn --bind 0.0.0.0:8080 --timeout "${GUNICORN_TIMEOUT:-60}" --workers "$GUNICORN_WORKERS" "${@:-icekit.project.wsgi:application}"
else
	exec gunicorn --bind 0.0.0.0:8080 --timeout "${GUNICORN_TIMEOUT:-60}" --workers "$GUNICORN_WORKERS" "${@:-icekit.project.wsgi:application}"
fi
