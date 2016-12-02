#!/bin/bash

# Install Python requirements in the given directory, if they have changed.

cat <<EOF
# `whoami`@`hostname`:$PWD$ pip-install.sh $@
EOF

set -e

DIR="${1:-$PWD}"

mkdir -p "$DIR"
cd "$DIR"

if [[ -f requirements.txt ]]; then
	if [[ ! -s requirements.txt.md5 ]] || ! md5sum --status -c requirements.txt.md5 > /dev/null 2>&1; then
		echo "Python requirements in '$DIR' directory are out of date, 'requirements.txt' has been updated."
		pip install -r requirements.txt
		md5sum requirements.txt > requirements.txt.md5
	fi
fi

if [[ -f requirements-local.txt ]]; then
	if [[ ! -s requirements-local.txt.md5 ]] || ! md5sum --status -c requirements-local.txt.md5 > /dev/null 2>&1; then
		echo "Python requirements in '$DIR' directory are out of date, 'requirements-local.txt' has been updated."
		pip install -r requirements-local.txt
		md5sum requirements-local.txt > requirements-local.txt.md5
	fi
fi
