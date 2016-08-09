#!/bin/bash

cat <<EOF
#
###############################################################################
#
# `whoami`@`hostname`:$PWD$ pip-install.sh $@
#
# Install Python requirements in the given directory, if they have changed.
#
EOF

set -e

mkdir -p ${1:-.}
cd ${1:-.}

touch requirements.txt requirements-local.txt requirements.md5

if ! md5sum -c --status requirements.md5 > /dev/null 2>&1; then
    echo 'Python requirements are out of date.'
    if [[ -s requirements.txt ]]; then
        pip install --user -r requirements.txt
    fi
    if [[ -s requirements-local.txt ]]; then
        pip install --user -r requirements-local.txt
    fi
    md5sum requirements.txt requirements-local.txt > requirements.md5
fi
