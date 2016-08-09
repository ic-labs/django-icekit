#!/bin/bash

cat <<EOF
#
###############################################################################
#
# `whoami`@`hostname`:$PWD$ entrypoint.sh $@
#
# Install Node modules, install Python requirements, setup database, do cluster
# init (e.g. migrations), and execute command.
#
EOF

set -e

# Install Node modules.
waitlock.sh npm-install.sh
waitlock.sh npm-install.sh project

# Install Python requirements.
waitlock.sh pip-install.sh
waitlock.sh pip-install.sh project

# Setup database.
source setup-postgres-env.sh
waitlock.sh setup-postgres-database.sh

# Apply migrations.
waitlock.sh migrate.sh project/var

exec "${@:-bash}"
