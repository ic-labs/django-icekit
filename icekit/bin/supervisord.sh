#!/bin/bash

set -e

cat <<EOF
#
# READY.
#
EOF

exec supervisord --configuration "$ICEKIT_DIR/etc/supervisord.conf" "$@"
