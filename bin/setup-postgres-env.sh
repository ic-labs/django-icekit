#!/bin/bash

# Set 'PG*' variables. Default 'PGDATABASE' is derived from 'PROJECT_NAME' and
# git branch or 'BASE_SETTINGS_MODULE'.

cat <<EOF
echo # `whoami`@`hostname`:$PWD$ setup-postgres-env.sh
EOF

set -e

# Derive 'PGDATABASE' from 'PROJECT_NAME' and git branch or
# 'BASE_SETTINGS_MODULE', if not already defined.
if [[ -z "$PGDATABASE" ]]; then
    if [[ -d .git ]]; then
        export PGDATABASE="${PROJECT_NAME}_$(git rev-parse --abbrev-ref HEAD | sed 's/[^0-9A-Za-z]/_/g')"
        echo "Derived database name '$PGDATABASE' from 'PROJECT_NAME' environment variable and git branch."
    elif [[ -n "$BASE_SETTINGS_MODULE" ]]; then
        export PGDATABASE="${PROJECT_NAME}_$BASE_SETTINGS_MODULE"
        echo "Derived database name '$PGDATABASE' from 'PROJECT_NAME' and 'BASE_SETTINGS_MODULE' environment variables."
    else
        export PGDATABASE="$PROJECT_NAME"
        echo "Derived database name '$PGDATABASE' from 'PROJECT_NAME' environment variable."
    fi
fi

export PGHOST="${PGHOST:-postgres}"
export PGPORT="${PGPORT:-5432}"
export PGUSER="${PGUSER:-postgres}"
