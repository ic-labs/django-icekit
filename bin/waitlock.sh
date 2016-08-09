#!/bin/bash

cat <<EOF
#
###############################################################################
#
# `whoami`@`hostname`:$PWD$ waitlock.sh $@
#
# Execute cronlock in a loop to queue but avoid overlaps, instead of exiting
# when a lock is already acquired.
#
EOF

set -e

while true; do
    cronlock "$@" && STATUS="$?" || STATUS="$?"
    if [[ "$STATUS" == 200 ]]; then
        sleep 1
        continue
    fi
    break
done

exit "$STATUS"
