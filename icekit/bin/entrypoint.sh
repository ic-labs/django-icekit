#!/bin/bash

# Install Node modules, Bower components and Python requirements, setup
# database, apply migrations, and execute command.

cat <<EOF
# `whoami`@`hostname`:$PWD$ entrypoint.sh $@
EOF

set -e

# Make `pip install --user` the default.
pip() {
    if [[ "$1" == install ]]; then
        shift
        set -- install --user "$@"
    fi
    command pip "$@"
}
export -f pip

# Get number of CPU cores, so we know how many processes to run.
export CPU_CORES=$(python -c 'import multiprocessing; print multiprocessing.cpu_count();')

# Get project name from the project directory.
export ICEKIT_PROJECT_NAME=$(basename "$ICEKIT_PROJECT_DIR")

# Add bin directories to PATH.
export PATH="$ICEKIT_PROJECT_DIR/var/venv/bin:$ICEKIT_DIR/bin:$PATH"

# Use alternate installation (user scheme) for Python packages.
export PIP_SRC="$ICEKIT_PROJECT_DIR/var/venv/src"
export PYTHONUSERBASE="$ICEKIT_PROJECT_DIR/var/venv"

# Configure Python.
export PIP_DISABLE_PIP_VERSION_CHECK=on
export PYTHONHASHSEED=random
export PYTHONWARNINGS=ignore

# Get Redis host and port.
export REDIS_ADDRESS="${REDIS_ADDRESS:-localhost:6379}"

# The default is `django` and `no-docker`. This is overridden in Dockerfile to
# be just `django`.
export SUPERVISORD_CONFIG_INCLUDE="${SUPERVISORD_CONFIG_INCLUDE:-supervisord-django.conf supervisord-no-docker.conf}"

# Install Node modules.
waitlock.sh npm-install.sh "$ICEKIT_DIR"
waitlock.sh npm-install.sh "$ICEKIT_PROJECT_DIR"

# Install Bower components.
waitlock.sh bower-install.sh "$ICEKIT_DIR"
waitlock.sh bower-install.sh "$ICEKIT_PROJECT_DIR"

# Install Python requirements.
waitlock.sh pip-install.sh "$ICEKIT_PROJECT_DIR"

# Setup database.
source setup-postgres-env.sh
waitlock.sh setup-postgres-database.sh

# Apply migrations.
waitlock.sh migrate.sh "$ICEKIT_PROJECT_DIR/var"

# Open a new shell by default.
exec "${@:-bash}"
