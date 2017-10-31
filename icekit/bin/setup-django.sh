#!/bin/bash

# Install Node modules, Bower components and Python requirements, create a
# database, apply Django migrations, and execute a command.

cat <<EOF
# `whoami`@`hostname`:$PWD$ setup-django.sh $@
EOF

set -e

if [[ -n "$WAITLOCK_ENABLE" ]]; then
	cat <<EOF
#
# Do not be alarmed if you see "Waiting to acquire lock for command:" for
# several minutes at a time. It might seem like nothing is happening, but the
# command is already running in another background container.
#
# You can see the logs for all containers with:
#
#     $ docker-compose logs -f
#
EOF
fi

# Install Node modules.
waitlock.sh npm-install.sh "$ICEKIT_PROJECT_DIR"

# Install Bower components for the project.
waitlock.sh bower-install.sh "$ICEKIT_PROJECT_DIR"

# Install Bower components for icekit.
waitlock.sh bower-install.sh "$ICEKIT_DIR"

# Install Python requirements.
waitlock.sh pip-install.sh "$ICEKIT_PROJECT_DIR"

# Create a database.
waitlock.sh setup-postgres.sh

# Apply migrations.
waitlock.sh migrate.sh "$ICEKIT_PROJECT_DIR/var"

# Execute command.
exec "$@"
