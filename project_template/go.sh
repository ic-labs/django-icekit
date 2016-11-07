#!/bin/bash

# Configures the environment so we can run entrypoint.sh and other scripts.

cat <<EOF
# `whoami`@`hostname`:$PWD$ go.sh $@
EOF

set -e

# Get absolute project directory from the location of this script.
# See: http://stackoverflow.com/a/4774063
export ICEKIT_PROJECT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd -P)

# Set location of virtualenv.
export ICEKIT_VENV="$ICEKIT_PROJECT_DIR/var/go.sh-venv"

# Create local (non-Docker) virtualenv.
if [[ ! -d "$ICEKIT_VENV" ]]; then
    virtualenv "$ICEKIT_VENV"
fi

# Install ICEKit project.
if [[ -z $("$ICEKIT_VENV/bin/python" -m pip freeze | grep django-icekit) ]]; then
    "$ICEKIT_VENV/bin/python" -m pip install -r requirements-icekit.txt
fi

# Get absolute directory for the `icekit` package.
export ICEKIT_DIR=$("$ICEKIT_VENV/bin/python" -c "import icekit, os, sys; sys.stdout.write('%s\n' % os.path.dirname(icekit.__file__));")

# Execute entrypoint and command.
exec "$ICEKIT_DIR/bin/entrypoint.sh" ${@:-setup-django.sh bash.sh}
