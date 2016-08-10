#!/bin/bash

# Apply Django migrations, if they are out of date.

cat <<EOF
# `whoami`@`hostname`:$PWD$ migrate.sh $@
EOF

set -e

DIR="${1:-$PWD}"

mkdir -p "$DIR"
cd "$DIR"

touch migrate.txt.md5
manage.py migrate --list > migrate.txt

if ! md5sum -c --status migrate.txt.md5 > /dev/null 2>&1; then
    echo 'Migrations are out of date.'
    manage.py migrate --noinput
    manage.py migrate --list > migrate.txt
    md5sum migrate.txt > migrate.txt.md5
else
    echo 'Migrations are already up to date.'
fi
