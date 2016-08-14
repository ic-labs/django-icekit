#!/bin/bash

# Wrapper for 'entrypoint.sh' that defines 'ICEKIT_PROJECT_DIR', first.

cat <<EOF
# `whoami`@`hostname`:$PWD$ go.sh $@
EOF

set -e

ICEKIT_PROJECT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)

exec entrypoint.sh "$@"
