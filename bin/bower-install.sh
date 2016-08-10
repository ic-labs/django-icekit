#!/bin/bash

# Install Bower components in the given directory, if they have changed.

cat <<EOF
# `whoami`@`hostname`:$PWD$ bower-install.sh $@
EOF

set -e

DIR="${1:-$PWD}"

mkdir -p "$DIR"
cd "$DIR"

touch bower.json bower.json.md5

if [[ -s bower.json ]] && ! md5sum -c --status bower.json.md5 > /dev/null 2>&1; then
    echo "Bower components in $DIR are out of date."
    bower install --allow-root
    md5sum bower.json > bower.json.md5
else
    echo "Bower components in $DIR are already up to date."
fi
