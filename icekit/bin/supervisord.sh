#!/bin/bash

set -e

exec supervisord --configuration "$ICEKIT_PROJECT_DIR/etc/supervisord.conf" "$@"
