#!/bin/bash

cat <<EOF
#
###############################################################################
#
# `whoami`@`hostname`:$PWD$ migrate.sh $@
#
# Apply Django migrations, if they are out of date.
#
EOF

set -e

DIR=${1:-.}
DIR=${DIR%/}  # Strip trailing slash

mkdir -p $DIR

touch "$DIR/migrate.txt.md5"
python manage.py migrate --list > "$DIR/migrate.txt"

if ! md5sum -c --status "$DIR/migrate.txt.md5" > /dev/null 2>&1; then
    echo 'Migrations are out of date.'
    python manage.py migrate --noinput
    python manage.py migrate --list > "$DIR/migrate.txt"
    md5sum "$DIR/migrate.txt" > "$DIR/migrate.txt.md5"
fi
