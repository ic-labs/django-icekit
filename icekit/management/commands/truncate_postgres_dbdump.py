import sys  # Needed to output unicode see https://code.djangoproject.com/ticket/21933
import re

from django.core.management.base import BaseCommand, CommandError


COPY_TABLENAME_RE = re.compile(r'^COPY ([^ ]+) .* FROM stdin;$')


class Command(BaseCommand):
    help = ("Truncate unwanted table data in PostgreSQL DB dump files."
            " Output is written to STDOUT")
    args = '<pg_dump.sql> <table_to_truncate> [<table2_to_truncate>...]'

    def handle(self, *args, **options):
        if len(args) < 2:
            raise CommandError(
                "The <pg_dump.sql> and at least one <table_to_truncate>"
                " arguments are required")

        filepath = args[0]
        tables_to_truncate = args[1:]

        truncating = False
        with open(filepath, 'rb') as infile:
            for line in infile:
                # If we are truncating a COPY block, stop doing so when we
                # reach the end-of-COPY marker '\.'
                if truncating:
                    if line.startswith('\.'):
                        truncating = False
                    else:
                        continue
                # If we encounter a COPY block...
                if line.startswith('COPY '):
                    # ...and the table name matches one we wish to truncate...
                    match = COPY_TABLENAME_RE.match(line)
                    tablename = match and match.group(1)
                    # ...print a comment and start truncating lines
                    if tablename in tables_to_truncate:
                        truncating = True
                        sys.stdout.write("--- TRUNCATED DATA ---\n")
                # Echo most file lines to output, unless they are skipped
                # during truncation above.
                sys.stdout.write(line)
