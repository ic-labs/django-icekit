#!/bin/bash

# Configure environment, install Node modules, Bower components and Python
# requirements, setup database, apply migrations, and execute command.

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

COMMAND="${@:-bash}"

if [[ "$COMMAND" == bash ]]; then
    cat <<EOF

You are running an interactive shell. Here's a list of commands you might want
to run:

    bower-install.sh <DIR>
        Change to <DIR> and execute 'bower install', *if* 'bower.json' has been
        updated since the last time it was run.

    celery.sh
        Start Celery. This is normally managed by Docker or Supervisord, and is
        not normally used interactively.

    celerybeat.sh
        Start Celery Beat. This is normally managed by Docker or Supervisord,
        and is not normally used interactively.

    celeryflower.sh
        Start Celery Flower. This is normally managed by Docker or Supervisord,
        and is not normally used interactively.

    gunicorn.sh
        Start Gunicorn. This is normally managed by Docker or Supervisord, and
        is not normally used interactively.

    manage.py [SUBCOMMAND [ARGUMENTS]]
        Run a Django management command.

    migrate.sh
        Apply Django migrations, *if* the migrations on disk have been updated
        since the last time it was run.

    nginx.sh
        Start Nginx. This is normally managed by Docker or Supervisord, and is
        not normally used interactively.

    npm-install.sh <DIR>
        Change to <DIR> and execute 'npm install', *if* 'package.json' has been
        updated since the last time it was run.

    pip-install.sh <DIR>
        Change to <DIR> and execute 'pip install', *if* 'requirements.txt' or
        'requirements-local.txt' have been updated since the last time it was
        run.

    runserver.sh
        Start the Django development server.

    setup-postgres-database.sh
        Create a PostgreSQL database with a name derived from the current Git
        branch and project directory. Seed the new database it with data from
        the 'SRC_PG*' environment variables, if defined.

    supervisorctl.sh [OPTIONS] [ACTION [ARGUMENTS]]
        Run 'supervisorctl'. When using Docker, use this to manage Gunicorn and
        Nginx. When not using Docker, it also manages Celery, Celery Beat and
        Celery Flower.

    supervisord.sh
        Start Supervisord. This is normally managed by Docker, and is usually
        only used interactively when not using Docker.

EOF
fi

exec $COMMAND
