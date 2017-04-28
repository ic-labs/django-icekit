#!/bin/bash

# Run tests. Set 'QUICK=1' reuse the test database and collected static and
# compressed files.

cat <<EOF
# `whoami`@`hostname`:$PWD$ runtests.sh $@
EOF

set -e

export BASE_SETTINGS_MODULE=test
export REUSE_DB=1
export SRC_PGDATABASE="$ICEKIT_PROJECT_DIR/test_initial_data.sql"

# Only drop eisting database when QUICK is not set.
[[ -z "$QUICK" ]] && export SETUP_POSTGRES_FORCE=1

PGDATABASE="test_$PGDATABASE" setup-postgres.sh
manage.py migrate --noinput

# Only collect and compress static files when QUICK is not set or when it has
# never been done before.
[[ -z "$QUICK" || ! -d "$ICEKIT_PROJECT_DIR/static_root" ]] && manage.py collectstatic --noinput --verbosity=0
[[ -z "$QUICK" || ! -f "$ICEKIT_PROJECT_DIR/static_root/CACHE/manifest.json" ]] && manage.py compress --force --verbosity=0

coverage run "$ICEKIT_DIR/bin/manage.py" test --noinput --verbosity=2 "${@:-.}"
coverage report

if [[ -n "$TRAVIS" ]]; then
	coveralls || true
fi
