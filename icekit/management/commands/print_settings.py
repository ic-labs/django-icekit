from collections import OrderedDict
from optparse import make_option

from django.core.management.base import BaseCommand
try:
    import json
except ImportError:
    from django.utils import simplejson as json


class MyEncoder(json.JSONEncoder):
    """ Handle items that cannot be JSON-encoded by converting to strings """

    def default(self, o):
        try:
            return super(MyEncoder, self).default(o)
        except TypeError:
            return unicode(o)


# This is based on https://github.com/msabramo/django-print-settings
class Command(BaseCommand):
    help = '''
           Print out site settings, sorted alphabetically.

           To print the settings for a specific environment set the
           appropriate environment variable:

               BASE_SETTINGS_MODULE=production manage.py print_settings
           '''

    option_list = BaseCommand.option_list + (
        make_option('--format', default='yaml', dest='format',
                    help='Output format, e.g. yaml'),
        make_option('--indent', default=4, dest='indent', type='int',
                    help='Specifies indent level for JSON and YAML'),
    )

    def handle(self, *args, **options):
        from django.conf import settings

        settings_names = [
            name for name in sorted(dir(settings))
            # Ignore single- and double-underscore attribute names
            if not name.startswith('_')
        ]
        settings_to_print = OrderedDict([
            (name, getattr(settings, name))
            for name in settings_names
        ])

        output_format = options.get('format', 'json')
        indent = options.get('indent', 4)

        if output_format == 'json':
            print(json.dumps(settings_to_print, indent=indent, cls=MyEncoder))
        elif output_format == 'yaml':
            import yaml  # requires PyYAML
            print(yaml.dump(settings_to_print, indent=indent))
        else:
            raise ValueError("--format must be 'json' or 'yaml'")
