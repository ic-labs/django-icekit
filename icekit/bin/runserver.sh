#!/bin/bash

set -e

exec python "$ICEKIT_DIR/manage.py" runserver "${@:-0.0.0.0:8080}"
