#!/bin/bash

cat <<EOF
#
###############################################################################
#
# `whoami`@`hostname`:$PWD$ npm-install.sh $@
#
# Install Node modules in the given directory, if they have changed.
#
EOF

set -e

mkdir -p ${1:-.}
cd ${1:-.}

touch package.json package.json.md5

if [[ -s package.json ]] && ! md5sum -c --status package.json.md5 > /dev/null 2>&1; then
    echo 'Node modules are out of date.'
    npm install
    md5sum package.json > package.json.md5
fi
