#!/bin/bash

set -e

cat <<EOF
#
# READY.
#
EOF

exec manage.py runserver "${@:-0.0.0.0:8000}"
