#!/bin/bash

# Configure the environment so we can run `entrypoint.sh` and other scripts.

cat <<EOF
# `whoami`@`hostname`:$PWD$ go.sh $@
EOF

set -e

# Get absolute project directory from the location of this script.
# See: http://stackoverflow.com/a/4774063
export PROJECT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd -P)

# Set location of virtualenv.
export PROJECT_VENV_DIR="${VIRTUAL_ENV:-$PROJECT_DIR/var/go.sh-venv}"

# Create virtualenv.
if [[ ! -d "$PROJECT_VENV_DIR" ]]; then
    virtualenv "$PROJECT_VENV_DIR"
fi

# Install ICEkit.
if [[ -z $("$PROJECT_VENV_DIR/bin/python" -m pip freeze | grep django-icekit) ]]; then
    "$PROJECT_VENV_DIR/bin/python" -m pip install -r requirements-icekit.txt
fi

# Execute entrypoint and command.
exec "$PROJECT_VENV_DIR/bin/entrypoint.sh" ${@:-setup-django.sh bash.sh}
