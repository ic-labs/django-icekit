#!/bin/bash

# An entrypoint script that sets the 'ICEKIT_PROJECT_DIR' environment variable
# and executes a command.

ICEKIT_PROJECT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)

exec "$@"
