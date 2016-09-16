#!/bin/bash

# Run tests.

cat <<EOF
# `whoami`@`hostname`:$PWD$ runtests.sh $@
EOF

set -e

export BASE_SETTINGS_MODULE=test
export REUSE_DB=1
export SETUP_POSTGRES_FORCE=1
export SRC_PGDATABASE="$ICEKIT_PROJECT_DIR/test_initial_data.sql"

unset WAITLOCK_ENABLED

PGDATABASE="test_$PGDATABASE" setup-postgres.sh
migrate.sh

manage.py collectstatic --noinput --verbosity=0
manage.py compress --verbosity=0

coverage run "$ICEKIT_DIR/bin/manage.py" test --noinput --verbosity=2 "${@:-$RUNTESTS_ARGS}"
coverage report

if [[ -n "$TRAVIS" ]]; then
    coveralls
fi
