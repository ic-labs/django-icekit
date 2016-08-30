#!/bin/bash

# Configures the environment so we can run entrypoint.sh and other scripts.

cat <<EOF
# `whoami`@`hostname`:$PWD$ go.sh $@
EOF

set -e

# Get absolute project directory from the location of this script.
# See: http://stackoverflow.com/a/4774063
export ICEKIT_PROJECT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd -P)

# Use alternate installation (user scheme) for Python packages.
export PIP_SRC="$ICEKIT_PROJECT_DIR/var/venv/src"
export PYTHONUSERBASE="$ICEKIT_PROJECT_DIR/var/venv"

# Install ICEkit, if necessary.
if [[ -z $(pip freeze | grep django-icekit) ]]; then
    pip install --user -r requirements.txt
fi

# Get absolute directory for the `icekit` package.
export ICEKIT_DIR=$(python -c 'import icekit, os; print os.path.dirname(icekit.__file__);')

# Add bin directories to PATH.
export PATH="$ICEKIT_PROJECT_DIR/var/venv/bin:$ICEKIT_DIR/bin:$PATH"

# Execute the entrypoint script by default.
exec "${@:-entrypoint.sh}"
