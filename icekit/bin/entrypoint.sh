#!/bin/bash

# Configure the environment and execute a command.

cat <<EOF
# `whoami`@`hostname`:$PWD$ entrypoint.sh $@
EOF

set -e

if [[ -n "${DOCKER+1}" ]]; then
    # In our Docker image, the only system site packages are the ones that we
    # have installed, so we do not need a virtualenv for isolation. Using an
    # isolated virtualenv would mean we have to reinstall everything during
    # development, even when no versions have changed. Using a virtualenv
    # created with `--system-site-packages` would mean we can avoid
    # reinstalling everything, but pip would try to uninstall existing packages
    # when we try to install a new version, which can fail with permissions
    # errors (e.g. when running as an unprivileged user or when the image is
    # read-only). The alternate installation user scheme avoids these problems
    # by ignoring existing system site packages when installing a new version,
    # instead of trying to uninstall them.
    # See: https://pip.pypa.io/en/stable/user_guide/#user-installs

    # Make `pip install --user` the default.
    pip() {
        if [[ "$1" == install ]]; then
            shift
            set -- install --user "$@"
        fi
        command pip "$@"
    }
    export -f pip

    # Set location of userbase directory.
    export PYTHONUSERBASE="$ICEKIT_PROJECT_DIR/var/docker-pythonuserbase"

    # Add userbase bin directory to PATH.
    export PATH="$PYTHONUSERBASE/bin:$PATH"

    # Install editable packages into userbase src directory.
    export PIP_SRC="$PYTHONUSERBASE/src"

    # For some reason pip allows us to install sdist packages, but not editable
    # packages, when this directory doesn't exist. So make sure it does.
    mkdir -p "$PYTHONUSERBASE/lib/python2.7/site-packages"
else
    # Fail loudly when required environment variables are missing.
    for var in ICEKIT_DIR ICEKIT_PROJECT_DIR ICEKIT_VENV; do
        eval [[ -z \${$var+1} ]] && {
            >&2 echo "ERROR: Missing environment variable: $var"
            exit 1
        }
    done

    # Fail loudly when required programs are missing.
    for cmd in elasticsearch md5sum nginx npm psql python pv redis-server; do
        hash $cmd 2>/dev/null || {
            >&2 echo "ERROR: Missing program: $cmd"
            exit 1
        }
    done

    # Add ICEkit and virtualenv bin directories to PATH.
    export PATH="$ICEKIT_DIR/bin:$ICEKIT_VENV/bin:$PATH"
fi

# Set default base settings module.
export BASE_SETTINGS_MODULE="${BASE_SETTINGS_MODULE:-develop}"

# Get number of CPU cores, so we know how many processes to run.
export CPU_CORES=$(python -c 'import multiprocessing; print multiprocessing.cpu_count();')

# Get project name from the project directory.
export ICEKIT_PROJECT_NAME=$(basename "$ICEKIT_PROJECT_DIR")

# Add project bin directory to PATH.
export PATH="$ICEKIT_PROJECT_DIR/bin:$PATH"

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

# Default PostgreSQL credentials.
export PGHOST="${PGHOST:-localhost}"
export PGPORT="${PGPORT:-5432}"
export PGUSER="${PGUSER:-$(whoami)}"

# Get Redis host and port.
export REDIS_ADDRESS="${REDIS_ADDRESS:-localhost:6379}"

# The default is `django` and `no-docker`. This is overridden in Dockerfile to
# be just `django`.
export SUPERVISORD_CONFIG_INCLUDE="${SUPERVISORD_CONFIG_INCLUDE:-supervisord-django.conf supervisord-no-docker.conf}"

# Run bash by default without any user customisations from rc or profile files
# to reduce the chance of user customisations clashing with our paths etc.
DEFAULT_SHELL_COMMAND="bash --norc --noprofile"

COMMAND="${@:-$DEFAULT_SHELL_COMMAND}"

if [[ "$COMMAND" == "$DEFAULT_SHELL_COMMAND" ]]; then
    cat <<EOF

You are running an interactive shell. Here is a list of frequently used
commands you might want to run:

    bower-install.sh <DIR>
    celery.sh
    celerybeat.sh
    celeryflower.sh
    gunicorn.sh
    manage.py [COMMAND [ARGS]]
    migrate.sh
    nginx.sh
    npm-install.sh <DIR>
    pip-install.sh <DIR>
    runserver.sh [ARGS]
    runtests.sh [ARGS]
    setup-django.sh [COMMAND]
    setup-postgres.sh
    supervisorctl.sh [OPTIONS] [ACTION [ARGS]]
    supervisord.sh [ARGS]
    transfer.sh <FILE>

For more info on each command, run:

    help.sh

EOF
fi

exec $COMMAND
