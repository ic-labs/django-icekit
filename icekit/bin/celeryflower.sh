#!/bin/bash

set -e

exec celery --app=icekit.project flower
