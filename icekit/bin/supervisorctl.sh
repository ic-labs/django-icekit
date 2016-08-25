#!/bin/bash

set -e

exec supervisorctl --configuration "$ICEKIT_PROJECT_DIR/etc/supervisord.conf" "$@"
