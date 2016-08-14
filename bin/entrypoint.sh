#!/bin/bash

# Install Node modules, Bower components and Python requirements, setup
# database, apply migrations, and execute command.

cat <<EOF
# `whoami`@`hostname`:$PWD$ entrypoint.sh $@
EOF

set -e

export ICEKIT_DIR=$(python -c 'import icekit, os; print os.path.dirname(icekit.__file__);')
export PIP_DISABLE_PIP_VERSION_CHECK=on
export PIP_SRC="$ICEKIT_PROJECT_DIR/venv/src"
export PROJECT_NAME=$(basename "$ICEKIT_PROJECT_DIR")
export PYTHONHASHSEED=random
export PYTHONUSERBASE="$ICEKIT_PROJECT_DIR/venv"
export PYTHONWARNINGS=ignore

# Install Node modules.
waitlock.sh npm-install.sh "$ICEKIT_DIR"
waitlock.sh npm-install.sh "$ICEKIT_PROJECT_DIR"

# Install Bower components.
waitlock.sh bower-install.sh "$ICEKIT_DIR"
waitlock.sh bower-install.sh "$ICEKIT_PROJECT_DIR"

# Install Python requirements.
waitlock.sh pip-install.sh "$ICEKIT_DIR"
waitlock.sh pip-install.sh "$ICEKIT_PROJECT_DIR"

# Setup database.
source setup-postgres-env.sh
waitlock.sh setup-postgres-database.sh

# Apply migrations.
waitlock.sh migrate.sh "$ICEKIT_PROJECT_DIR/var"

exec "${@:-bash}"
