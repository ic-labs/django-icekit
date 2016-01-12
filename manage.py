#!/usr/bin/env python
import coverage
import os
import sys

if __name__ == "__main__":

    if 'test' in sys.argv:
        cov = coverage.coverage()
        cov.erase()
        cov.start()

    os.environ.setdefault(
        "DJANGO_SETTINGS_MODULE", "icekit.tests.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)

    if 'test' in sys.argv:
        cov.stop()
        cov.save()
        cov.report()
        cov.html_report()
