#!/usr/bin/env python

from __future__ import print_function

import os
import sys


if __name__ == "__main__":
    ICEKIT_PROJECT_DIR = os.environ.get('ICEKIT_PROJECT_DIR')
    if not ICEKIT_PROJECT_DIR:
        print("'ICEKIT_PROJECT_DIR' is not defined.", file=sys.stderr)
        exit(1)

    # Add project dir to Python path
    if ICEKIT_PROJECT_DIR not in sys.path:
        sys.path.insert(0, ICEKIT_PROJECT_DIR)

    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "icekit.project.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
