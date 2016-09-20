#!/bin/bash

# Create a database for 'PG*'. If 'SRC_PGDATABASE' ('initial_data.sql' in
# 'ICEKIT_PROJECT_DIR' by default) is an '*.sql' file, try to restore it.
# Otherwise, 'SRC_PGDATABASE' should be the name of a database to dump and
# restore from 'SRC_PG*' (which match 'PG*' by default).

cat <<EOF
# `whoami`@`hostname`:$PWD$ setup-postgres.sh
EOF

set -e

# Wait for PostgreSQL to become available.
COUNT=0
until psql -l > /dev/null 2>&1; do
    if [[ "$COUNT" == 0 ]]; then
        echo "Waiting for PostgreSQL ($PGUSER@$PGHOST:$PGPORT)..."
    fi
    (( COUNT += 1 ))
    sleep 1
done
if (( COUNT > 0 )); then
    echo "Waited $COUNT seconds for PostgreSQL."
fi

# Database does not exist.
if psql -l | grep -q "\b$PGDATABASE\b"; then
    if [[ -z "$SETUP_POSTGRES_FORCE" ]]; then
        echo "Database '$PGDATABASE' already exists."
        exit 0
    else
        echo "Database '$PGDATABASE' already exists and SETUP_POSTGRES_FORCE is set. Drop existing database."
        dropdb "$PGDATABASE"
    fi
fi

# Create database.
echo "Create database '$PGDATABASE'."
createdb "$PGDATABASE"

# Restore from file or source database.
SRC_PGDATABASE="${SRC_PGDATABASE:-$ICEKIT_PROJECT_DIR/initial_data.sql}"
if [[ "$SRC_PGDATABASE" == *.sql ]]; then
    if [[ -f "$SRC_PGDATABASE" ]]; then
        echo "Restore to database '$PGDATABASE' from file '$SRC_PGDATABASE'."
        pv "$SRC_PGDATABASE" | psql -d "$PGDATABASE" > /dev/null
    fi
elif [[ -n "$SRC_PGDATABASE" ]]; then
    # Get source database credentials.
    SRC_PGHOST="${SRC_PGHOST:-${PGHOST}}"
    SRC_PGPASSWORD="${SRC_PGPASSWORD:-${PGPASSWORD}}"
    SRC_PGPORT="${SRC_PGPORT:-${PGPORT}}"
    SRC_PGUSER="${SRC_PGUSER:-${PGUSER}}"
    # Wait for PostgreSQL to become available.
    COUNT=0
    until PGPASSWORD="$SRC_PGPASSWORD" psql -l -h "$SRC_PGHOST" -p "$SRC_PGPORT" -U "$SRC_PGUSER" > /dev/null 2>&1; do
        if [[ "$COUNT" == 0 ]]; then
            echo "Waiting for PostgreSQL ($SRC_PGUSER@$SRC_PGHOST:$SRC_PGPORT)..."
        fi
        (( COUNT += 1 ))
        sleep 1
    done
    if (( COUNT > 0 )); then
        echo "Waited $COUNT seconds for PostgreSQL."
    fi
    echo "Restore database '$PGDATABASE' from source database '$SRC_PGDATABASE' on tcp://$SRC_PGHOST:$SRC_PGPORT."
    PGPASSWORD="$SRC_PGPASSWORD" pg_dump -d "$SRC_PGDATABASE" -h "$SRC_PGHOST" -p "$SRC_PGPORT" -U "$SRC_PGUSER" -O -x | pv | psql -d "$PGDATABASE" > /dev/null
fi
