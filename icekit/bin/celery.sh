#!/bin/bash

set -e

export C_FORCE_ROOT=1

exec celery --app=icekit.project worker --loglevel=INFO
