#!/bin/bash

# Wrapper for 'entrypoint.sh' that defines 'ICEKIT_DIR', 'ICEKIT_PROJECT_DIR',
# and 'PATH' environment variables, first.

cat <<EOF
# `whoami`@`hostname`:$PWD$ go.sh $@
EOF

set -e

export ICEKIT_DIR=$(python -c 'import icekit, os; print os.path.dirname(icekit.__file__);')
export ICEKIT_PROJECT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)
export PATH="$ICEKIT_DIR/bin:$PATH"

exec entrypoint.sh "$@"
