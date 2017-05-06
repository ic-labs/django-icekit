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

# Install `ixc-django-docker` package.
if [[ -f requirements.txt ]]; then
	if [[ ! -s requirements.txt.md5 ]] || ! md5sum --status -c requirements.txt.md5 > /dev/null 2>&1; then
		"$PROJECT_VENV_DIR/bin/python" -m pip install --no-cache-dir --no-deps -r <(grep -v setuptools requirements.txt)  # Unpin setuptools dependencies. See: https://github.com/pypa/pip/issues/4264
		md5sum requirements.txt > requirements.txt.md5
	fi
fi

# Execute entrypoint and command.
exec "$PROJECT_VENV_DIR/bin/entrypoint.sh" ${@:-setup-django.sh bash.sh}
