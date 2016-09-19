#!/bin/bash

# Install Node modules, Bower components and Python requirements, create a
# database, apply Django migrations, and execute a command.

set -e

# Install Node modules.
waitlock.sh npm-install.sh "$ICEKIT_PROJECT_DIR"

# Install Bower components.
waitlock.sh bower-install.sh "$ICEKIT_PROJECT_DIR"

# Install Python requirements.
waitlock.sh pip-install.sh "$ICEKIT_PROJECT_DIR"

# Create a database.
waitlock.sh setup-postgres.sh

# Apply migrations.
waitlock.sh migrate.sh "$ICEKIT_PROJECT_DIR/var"

# Execute command.
exec "$@"
