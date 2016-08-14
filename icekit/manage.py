#!/usr/bin/env python

from __future__ import print_function

import os
import sys


def main():
    if not os.environ.get('ICEKIT_PROJECT_DIR'):
        print("'ICEKIT_PROJECT_DIR' is not defined.", file=sys.stderr)
        exit(1)

    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "icekit.project.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)

if __name__ == "__main__":
    main()
