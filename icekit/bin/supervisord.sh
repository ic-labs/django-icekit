#!/bin/bash

set -e

exec supervisord --configuration "$ICEKIT_DIR/etc/supervisord.conf" "$@"
