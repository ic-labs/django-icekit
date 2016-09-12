#!/bin/bash

set -e

# See: http://nginx.org/en/docs/ngx_core_module.html#worker_processes
NGINX_WORKER_PROCESSES="${NGINX_WORKER_PROCESSES:-${CPU_CORES:-1}}"

exec nginx -c "$ICEKIT_DIR/etc/nginx.conf" -g "worker_processes $NGINX_WORKER_PROCESSES;" "$@"
