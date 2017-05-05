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

# Don't write `*.pyc` files.
export PYTHONDONTWRITEBYTECODE=1

# Create virtualenv.
if [[ ! -d "$ICEKIT_VENV" ]]; then
    virtualenv "$ICEKIT_VENV"
fi

# Install ICEKit.
if [[ -z $("$ICEKIT_VENV/bin/python" -m pip freeze | grep django-icekit) ]]; then
	bash -c "'$ICEKIT_VENV/bin/python' -m pip install --no-cache-dir --no-deps -r <(grep -v setuptools requirements.txt)"  # Unpin setuptools dependencies. See: https://github.com/pypa/pip/issues/4264
	md5sum requirements.txt > requirements.txt.md5
fi

# Get absolute directory for the `icekit` package.
export ICEKIT_DIR=$("$ICEKIT_VENV/bin/python" -c "import icekit, os, sys; sys.stdout.write('%s\n' % os.path.dirname(icekit.__file__));")

# Execute entrypoint and command.
exec "$ICEKIT_DIR/bin/entrypoint.sh" ${@:-setup-django.sh bash.sh}
