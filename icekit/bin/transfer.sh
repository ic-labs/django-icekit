#!/bin/bash

set -e

if [ $# -eq 0 ]; then
    cat <<-EOF
Usage:
    $(basename "$0") /tmp/test.md
    cat /tmp/test.md | $(basename "$0") test.md
EOF
    exit 1
fi

if tty -s; then
    BASENAME=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
    URL=$(cat "$1" | xz | gpg -aco - | curl --progress-bar --upload-file - "https://transfer.sh/$BASENAME")
else
    URL=$(xz - | gpg -aco - | curl --progress-bar --upload-file - "https://transfer.sh/$1")
fi

cat <<EOF
To download:
    curl --progress-bar $URL | gpg -o - | unxz > $BASENAME
EOF
