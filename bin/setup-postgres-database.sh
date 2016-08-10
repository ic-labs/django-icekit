#!/bin/bash

# Create a database for 'PG*'. If 'SRC_PGDATABASE' is a file, restore it.
# Otherwise, it is assumed to be the name of a database to dump and restore
# from 'SRC_PG*', which match 'PG*' by default.

cat <<EOF
# `whoami`@`hostname`:$PWD$ setup-postgres-database.sh
EOF

set -e

# Wait for PostgreSQL to become available.
COUNT=0
until psql -l > /dev/null 2>&1; do
    if [[ "$COUNT" == 0 ]]; then
        echo 'Waiting for PostgreSQL...'
    fi
    (( COUNT += 1 ))
    sleep 1
done
if (( COUNT > 0 )); then
    echo "Waited $COUNT seconds for PostgreSQL."
fi

# Database does not exist.
if psql -l | grep -q "\b$PGDATABASE\b"; then
    echo "Database '$PGDATABASE' already exists."
    exit 0
fi

# Create database.
echo "Create database '$PGDATABASE'."
createdb "$PGDATABASE"

# Restore from file or source database.
INITIAL_DATA="${SRC_PGDATABASE:-initial_data.sql}"
if [[ -f "$INITIAL_DATA" ]]; then
    echo "Restore to database '$PGDATABASE' from file '$INITIAL_DATA'."
    pv "$INITIAL_DATA" | psql -d "$PGDATABASE" > /dev/null
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
            echo 'Waiting for PostgreSQL...'
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
