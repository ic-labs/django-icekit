#!/bin/bash

set -e

exec manage.py runserver "${@:-0.0.0.0:8000}"
