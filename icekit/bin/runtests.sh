#!/bin/bash

# Run tests.

cat <<EOF
# `whoami`@`hostname`:$PWD$ runtests.sh $@
EOF

set -e

export BASE_SETTINGS_MODULE=test
export REUSE_DB=1
export SRC_PGDATABASE="$ICEKIT_PROJECT_DIR/test_initial_data.sql"

PGDATABASE="test_$PGDATABASE" setup-postgres.sh
manage.py migrate --noinput

[[ ! -d "$ICEKIT_PROJECT_DIR/static_root" ]] && manage.py collectstatic --noinput --verbosity=0
[[ ! -f "$ICEKIT_PROJECT_DIR/static_root/CACHE/manifest.json" ]] && manage.py compress --verbosity=0

coverage run "$ICEKIT_DIR/bin/manage.py" test --noinput --verbosity=2 "${@:-.}"
coverage report

if [[ -n "$TRAVIS" ]]; then
    coveralls || true
fi
