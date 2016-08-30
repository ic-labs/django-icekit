#!/bin/bash

# Configure the environment and execute a command.

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

# Derive 'PGDATABASE' from 'ICEKIT_PROJECT_NAME' and git branch or
# 'BASE_SETTINGS_MODULE', if not already defined.
if [[ -z "$PGDATABASE" ]]; then
    if [[ -d .git ]]; then
        export PGDATABASE="${ICEKIT_PROJECT_NAME}_$(git rev-parse --abbrev-ref HEAD | sed 's/[^0-9A-Za-z]/_/g')"
        echo "Derived database name '$PGDATABASE' from 'ICEKIT_PROJECT_NAME' environment variable and git branch."
    elif [[ -n "$BASE_SETTINGS_MODULE" ]]; then
        export PGDATABASE="${ICEKIT_PROJECT_NAME}_$BASE_SETTINGS_MODULE"
        echo "Derived database name '$PGDATABASE' from 'ICEKIT_PROJECT_NAME' and 'BASE_SETTINGS_MODULE' environment variables."
    else
        export PGDATABASE="$ICEKIT_PROJECT_NAME"
        echo "Derived database name '$PGDATABASE' from 'ICEKIT_PROJECT_NAME' environment variable."
    fi
fi

export PGHOST="${PGHOST:-localhost}"
export PGPORT="${PGPORT:-5432}"
export PGUSER="${PGUSER:-$(whoami)}"

# Get Redis host and port.
export REDIS_ADDRESS="${REDIS_ADDRESS:-localhost:6379}"

# The default is `django` and `no-docker`. This is overridden in Dockerfile to
# be just `django`.
export SUPERVISORD_CONFIG_INCLUDE="${SUPERVISORD_CONFIG_INCLUDE:-supervisord-django.conf supervisord-no-docker.conf}"

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
