#!/usr/bin/env python

import os
import sys

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "icekit.project.settings")

from django.conf import settings
from django.core.management import execute_from_command_line


def abspath():
    print os.path.abspath(sys.argv[1])


def icekit_dir():
    print settings.ICEKIT_DIR


def main():
    print '# BASE_SETTINGS_MODULE: ' + settings.BASE_SETTINGS_MODULE
    execute_from_command_line(sys.argv)


def project_dir():
    print settings.PROJECT_DIR


if __name__ == "__main__":
    main()
