#!/bin/bash

# Install Bower components in the given directory, if they have changed.

cat <<EOF
# `whoami`@`hostname`:$PWD$ bower-install.sh $@
EOF

set -e

DIR="${1:-$PWD}"

mkdir -p "$DIR"
cd "$DIR"

if [[ ! -s bower.json ]]; then
    cat <<EOF > bower.json
{
  "name": "$ICEKIT_PROJECT_NAME",
  "dependencies": {
  },
  "private": true
}
EOF
fi

touch bower.json.md5

if [[ ! -s bower.json.md5 ]] || ! md5sum --status -c bower.json.md5 > /dev/null 2>&1; then
    echo "Bower components in '$DIR' directory are out of date."
    if [[ -d bower_components ]]; then
        echo 'Removing old Bower components directory.'
        rm -rf bower_components
    fi
    bower install --allow-root
    md5sum bower.json > bower.json.md5
fi
