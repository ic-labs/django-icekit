#!/bin/bash

# Install Python requirements in the given directory, if they have changed.

cat <<EOF
# `whoami`@`hostname`:$PWD$ pip-install.sh $@
EOF

set -e

DIR="${1:-$PWD}"

mkdir -p "$DIR"
cd "$DIR"

# For some reason pip allows us to install sdist packages, but not editable
# packages, when this directory doesn't exist. So make sure it does exist.
if [[ -n "$PYTHONUSERBASE" ]]; then
    mkdir -p "$PYTHONUSERBASE/lib/python2.7/site-packages"
fi

touch requirements.txt requirements-local.txt requirements.md5

if [[ ! -s requirements.md5 ]] || ! md5sum --status -c requirements.md5 > /dev/null 2>&1; then
    echo "Python requirements in '$DIR' directory are out of date."
    if [[ -s requirements.txt ]]; then
        pip install --user -r requirements.txt
    fi
    if [[ -s requirements-local.txt ]]; then
        pip install --user -r requirements-local.txt
    fi
    md5sum requirements.txt requirements-local.txt > requirements.md5
else
    echo "Python requirements in '$DIR' directory are already up to date."
fi
