#!/usr/bin/env python

"""
Create content plugins, page plugins, and projects from ICEkit templates.
"""

import argparse
import logging
import re
import os
import sys

from django.core.management import ManagementUtility

logging.basicConfig(format='%(message)s')
logger = logging.getLogger(__name__)

BASE_DIR = os.path.dirname(os.path.dirname(__file__))

COMMAND_CHOICES = (
    'startapp',
    'startproject',
)


def _err(*args):
    """
    Log error and exit.
    """
    logger.error(*args)
    exit(1)


# See: http://stackoverflow.com/a/30463972
def make_executable(path):
    mode = os.stat(path).st_mode
    mode |= (mode & 0o444) >> 2    # copy R bits to X
    os.chmod(path, mode)


def start_template(command, template, package_name, destination=None):
    """
    Use Django's `startapp` or `startproject` management commands with the
    given `template` to render the given template package as `package_name`
    to the `destination` directory.
    """
    # Start app or project?
    if command not in COMMAND_CHOICES:
        _err('Command %r not in available choices: %s' % (
            command,
            ', '.join(COMMAND_CHOICES),
        ))
    logger.debug('Command: %s' % command)

    # Template dir.
    logger.debug('Template: %s' % template)

    # Package name.
    package_name = re.sub(r'\W+', '_', package_name).strip('_')
    if not package_name:
        _err('Invalid package name: %s' % package_name)
    if package_name[0].isdigit():
        _err('Package name must not start with a digit: %s' % package_name)
    logger.debug('Package name: %s' % package_name)

    # Destination dir.
    destination = os.path.abspath(os.path.expanduser(os.path.expandvars(
        destination or package_name.replace('_', '-'))))
    if os.path.exists(destination):
        logger.debug('Destination directory already exists: %s' % destination)
        assert not os.listdir(destination)  # Existing directory must be empty
    else:
        logger.debug('Creating destination directory: %s' % destination)
        os.makedirs(destination)

    # Execute command.
    argv = [
        'django-admin.py',
        command,
        '--ext=json,ini,md,yml',
        '--name=.coveragerc,base.html,Dockerfile',
        '--template=%s' % template,
        package_name,
        destination,
    ]
    logger.debug('Executing command: %s' % ' '.join(argv))
    ManagementUtility(argv).execute()

    # TODO:
    # - chmod 755 bin/* manage.py
    # - git init
    # - git add -A
    # - git commit -m 'Initial commit.'

def main():
    parser = argparse.ArgumentParser(
        description='Management commands for ICEkit.',
    )
    group = parser.add_mutually_exclusive_group()
    group.add_argument(
        '-q',
        '--quiet',
        action='store_true',
        help='silence standard output',
    )
    group.add_argument(
        '-v',
        '--verbose',
        action='count',
        default=0,
        dest='verbosity',
        help='increase verbosity for each occurrence',
    )

    subparsers = parser.add_subparsers(
        title='subcommands',
        help='subcommand help',
    )

    # startcontentplugin
    startcontentplugin = subparsers.add_parser(
        'startcontentplugin',
        help='create a new content plugin',
    )
    startcontentplugin.set_defaults(
        command='startapp',
        template=os.path.join(BASE_DIR, 'content_plugin_template'),
    )

    # startpageplugin
    startpageplugin = subparsers.add_parser(
        'startpageplugin',
        help='create a new page plugin',
    )
    startpageplugin.set_defaults(
        command='startapp',
        template=os.path.join(BASE_DIR, 'page_plugin_template'),
    )

    # startproject
    startproject = subparsers.add_parser(
        'startproject',
        help='create a new project',
    )
    startproject.set_defaults(
        command='startproject',
        template='https://github.com/ixc/ixc-project-template/archive/master.zip',
    )

    # Common arguments for all subcommands.
    for p in (startcontentplugin, startpageplugin, startproject):
        p.add_argument(
            'package_name',
            help='non-word characters will be replaced with "_"',
        )
        p.add_argument(
            '-d',
            '--destination',
            help='directory where the new package will be created',
        )

    args = parser.parse_args()

    # Configure log level with verbosity argument.
    levels = (
        # logging.CRITICAL,
        # logging.ERROR,
        logging.WARNING,
        logging.INFO,
        logging.DEBUG,
    )
    try:
        logger.setLevel(levels[args.verbosity])
    except IndexError:
        logger.setLevel(logging.DEBUG)

    # Silence standard output.
    stdout = sys.stdout
    if args.quiet:
        sys.stdout = open(os.devnull, 'w')

    # Execute subcommand.
    start_template(
        command=args.command,
        template=args.template,
        package_name=args.package_name,
        destination=args.destination,
    )
    # if args.command == 'startproject':
    #     make_executable(os.path.join(args.destination, 'manage.py'))

    # Restore standard output.
    sys.stdout = stdout

if __name__ == '__main__':
    main()
