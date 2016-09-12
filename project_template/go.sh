#!/bin/bash

# Configures the environment so we can run entrypoint.sh and other scripts.

cat <<EOF
# `whoami`@`hostname`:$PWD$ go.sh $@
EOF

set -e

# Get absolute project directory from the location of this script.
# See: http://stackoverflow.com/a/4774063
export ICEKIT_PROJECT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd -P)

# Create virtualenv.
if [[ ! -d "$ICEKIT_PROJECT_DIR/var/venv/bin/pip" ]]; then
    virtualenv "$ICEKIT_PROJECT_DIR/var/venv"
fi

# Install ICEkit.
if [[ -z $("$ICEKIT_PROJECT_DIR/var/venv/bin/pip" freeze | grep django-icekit) ]]; then
    "$ICEKIT_PROJECT_DIR/var/venv/bin/pip" install -r requirements.txt
fi

# Get absolute directory for the `icekit` package.
export ICEKIT_DIR=$("$ICEKIT_PROJECT_DIR/var/venv/bin/python" -c 'import icekit, os; print os.path.dirname(icekit.__file__);')

# Execute entrypoint and command.
exec "$ICEKIT_DIR/bin/entrypoint.sh" "$@"
