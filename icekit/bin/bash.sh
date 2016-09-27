#!/bin/bash

# Run an interactive BASH shell, configured for ICEkit.

cat <<EOF
# `whoami`@`hostname`:$PWD$ bash.sh
EOF

set -e

cat <<EOF

You are running an interactive BASH shell, configured for ICEkit. Here is a
list of frequently used commands you might want to run:

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

# Run bash by default without any user customisations from rc or profile files
# to reduce the chance of user customisations clashing with our paths etc.
exec bash --norc --noprofile
