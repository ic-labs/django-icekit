import os
from optparse import make_option

import attr

from django.apps import apps
from django.conf import settings
from django.core.management.base import BaseCommand, CommandError
from django.contrib.auth import get_user_model
from django.utils import translation, timezone
from django.utils.encoding import smart_text

from icekit.utils.csv_unicode import UnicodeReader


class Command(BaseCommand):
    help = "Import pages from a CSV site map document"
    args = '<site_map.csv>'
    option_list = (
        make_option(
            '-l', '--levels', action='store', type=int,
            dest='levels', default=3,
            help="Number of level columns in site map (default: 3)"
        ),
        make_option(
            '-m', '--model', action='store',
            dest='model', default='layout_page.LayoutPage',
            help="Model to use when creating pages"
                 " (default: layout_page.LayoutPage)"
        ),
        make_option(
            '--author-id', action='store', type=int,
            dest='author-id', default=1,
            help="ID of user to assign as author of imported pages"
                 " (default: 1)"
        ),
        make_option(
            '--include-titles-with-brackets', action='store_true',
            dest='include-titles-with-brackets', default=False,
            help="Should rows with page titles surrounded by brackets --"
                 " () or [] -- be imported? (default: False)"
        ),
    ) + BaseCommand.option_list

    def log(self, msg, min_verbosity=1):
        if self.verbosity >= min_verbosity:
            self.stdout.write(smart_text(msg))

    def handle(self, *args, **options):
        if len(args) != 1:
            raise CommandError("The <site_map.csv> argument is required")
        file_path = args[0]
        if not os.path.exists(file_path):
            raise CommandError("File '%s' does not exist" % file_path)

        model_name = options.get('model')
        author_id = options.get('author-id')
        level_count = options.get('levels')
        include_titles_with_brackets = options.get(
            'include-titles-with-brackets')
        self.verbosity = options.get('verbosity', 1)

        # This will raise an exception if the model isn't available
        page_model = apps.get_model(model_name)

        user_model = get_user_model()

        author = user_model.objects.get(pk=author_id)
        self.log("Author for imported pages: %r" % author)

        translation.activate(settings.LANGUAGE_CODE)

        # Process CSV file to build a list of row entries to be created at the
        # end, *after* we have confirmed all data is valid
        entries = []
        existing_pages = {}
        with open(file_path, 'rb') as f:
            reader = UnicodeReader(f)

            headers = reader.next()
            check_headers(headers, level_count, file_path)

            parent_entry_by_level = {}
            for row, data in enumerate(reader, 2):
                entry = parse_line(data, level_count)

                if not entry.title:
                    self.log("SKIP row %d with no title: %s" % (row, data),
                             min_verbosity=2)
                    continue

                if not include_titles_with_brackets and \
                        entry.title[0] in ('[', '('):
                    self.log("SKIP row %d with title in brackets: '%s'"
                             % (row, entry.title))
                    continue

                # Store row data at each level so we can find the parent data
                # for following pages
                parent_entry_by_level[entry.level] = entry

                try:
                    existing_page = page_model.objects \
                        .get(translations__title=entry.title)
                    existing_pages[entry] = existing_page
                except page_model.DoesNotExist:
                    existing_page = None
                if existing_page:
                    self.log("SKIP row %d with title already in system: '%s'"
                             % (row, entry.title))
                    continue

                entry.parent_row_data = \
                    parent_entry_by_level.get(entry.level - 1)

                # Check we have a valid parent page for levels > 1
                if entry.level > 1 and not entry.parent_row_data:
                    raise Exception(
                        "Row %d does not have a parent page defined earlier"
                        " in the site map: %s" % (row, entry)
                    )
                entries.append(entry)

        # Create pages and related records
        for entry in entries:
            admin_notes = "IMPORTED by %s from file '%s' on %s" % (
                __name__.split('.')[-1],
                file_path,
                timezone.now().isoformat()
            )
            page = page_model.objects.language(settings.LANGUAGE_CODE).create(
                title=entry.title,
                author=author,
                override_url=entry.override_url,
                parent=existing_pages.get(entry.parent_row_data),
                brief=entry.brief,
                admin_notes=admin_notes,
            )
            self.log("CREATE page %r for row %d: %s"
                     % (page, row, entry))
            existing_pages[entry] = page


@attr.s
class RowData(object):
    """ Capture key details of a site map line entry """
    level = attr.ib()
    title = attr.ib()
    brief = attr.ib()
    alternative_titles = attr.ib()
    override_url = attr.ib()
    parent_row_data = attr.ib()


def parse_line(line, level_count):
    # Find level and title for first non-empty level column
    for level, title in enumerate(line[:level_count], 1):
        if title.strip():
            break
    return RowData(
        level=level,
        title=title,
        brief=line[level_count].strip(),
        alternative_titles=line[level_count + 1].strip(),
        override_url=line[level_count + 2].strip(),
        parent_row_data=None,  # Set elsewhere
    )


def check_headers(headers, level_count, file_path):
    expected_column_count = level_count + 3
    if len(headers) < expected_column_count:
        raise Exception(
            "Expected %s to have %d column headers (%d levels"
            " + Brief + Alternative Title + override_url) but it has"
            " %d headers"
            % (file_path, expected_column_count, level_count,
               len(headers))
        )

    for level_header in headers[:level_count]:
        if not level_header.strip().lower().startswith('level'):
            raise Exception(
                "First %d header names must start with 'Level' (case"
                " insensitive) but header '%s' does not"
                % (level_count, level_header)
            )

            raise Exception(
                "First %d header names must start with 'Level' (case"
                " insensitive) but header '%s' does not"
                % (level_count, level_header)
            )

    for col, header in enumerate(headers[level_count:], level_count):
        expected_header = {
            level_count: 'brief',
            level_count + 1: 'alternative titles',
            level_count + 2: 'override_url',
        }[col]
        clean_header = header.strip().lower()
        if not clean_header.startswith(expected_header):
            raise Exception(
                "Expected '%s' (case insensitive) for header in column %d"
                " but got '%s'"
                % (expected_header, col, clean_header)
            )
