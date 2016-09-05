#!/bin/bash

# Run tests.

cat <<EOF
# `whoami`@`hostname`:$PWD$ runtests.sh $@
EOF

set -e

export BASE_SETTINGS_MODULE=test
export PGDATABASE=test_icekit
export REUSE_DB=1
export SETUP_POSTGRES_FORCE=1
export SRC_PGDATABASE="$ICEKIT_DIR/initial_data.sql"

unset WAITLOCK_ENABLED

setup-postgres.sh
migrate.sh

manage.py collectstatic --noinput --verbosity=0
manage.py compress --verbosity=0

coverage run "$ICEKIT_DIR/bin/manage.py" test --noinput --verbosity=2 "${@:-icekit}"
coverage report

if [[ -n "$TRAVIS" ]]; then
    coveralls
fi
