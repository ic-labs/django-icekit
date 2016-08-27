#!/bin/bash

# Wrapper for 'entrypoint.sh' that defines 'ICEKIT_DIR' and
# 'ICEKIT_PROJECT_DIR', environment variables.

cat <<EOF
# `whoami`@`hostname`:$PWD$ go.sh $@
EOF

set -e

# We need to run additional services with Supervisord when not using Docker.
export EXTRA_SUPERVISORD_CONFIG=supervisord-no-docker.conf

# Get absolute directory for the `icekit` package.
export ICEKIT_DIR=$(python -c 'import icekit, os; print os.path.dirname(icekit.__file__);')

# Get absolute project directory from the location of this script.
# See: http://stackoverflow.com/a/4774063
export ICEKIT_PROJECT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}")/..; pwd -P)

# Execute wrapped entrypoint script.
exec "$ICEKIT_DIR/bin/entrypoint.sh" "$@"
