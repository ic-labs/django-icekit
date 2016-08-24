#!/bin/bash

# Run tests.

cat <<EOF
# `whoami`@`hostname`:$PWD$ runtests.sh $@
EOF

set -e

export BASE_SETTINGS_MODULE=test
export PGDATABASE="${PGDATABASE:-test_icekit}"
export REUSE_DB=1
export FORCE_SETUP_POSTGRES_DATABASE=1
export SRC_PGDATABASE=test_icekit.sql

exec entrypoint.sh bash -c "manage.py collectstatic --noinput --verbosity=0 && manage.py compress --verbosity=0 && manage.py test --noinput --verbosity=2 $@"
