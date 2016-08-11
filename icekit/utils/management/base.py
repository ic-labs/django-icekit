import logging
import time
from django import db
from django.core.management.base import BaseCommand
from optparse import make_option

logger = logging.getLogger(__name__)


class CronBaseCommand(BaseCommand):
    help = ('Long running process (indefinitely) that executes task on a '
            'specified interval (default is 1 min). The intent for the '
            'management command is to be used with `django-supervisor` or '
            'similar.')

    option_list = BaseCommand.option_list + (
        make_option(
            '-i',
            '--interval',
            dest='interval',
            type='int',
            help='Number of minutes to wait before executing task.',
            default=1
        ),
    )

    def handle(self, *args, **options):
        while True:
            self.task(*args, **options)
            self.cleanup()
            logger.info('Sleeping for %s min.', options['interval'])
            time.sleep(60 * options['interval'])

    def cleanup(self):
        """
        Performs clean-up after task is completed before it is executed again
        in the next internal.
        """
        # Closes connections to all databases to avoid the long running process
        # from holding connections indefinitely.
        for alias in db.connections.databases:
            logger.info('Closing database connection: %s', alias)
            db.connections[alias].close()

    def task(self, *args, **options):
        """
        The actual logic of the task to execute. Subclasses must implement
        this method.
        """
        raise NotImplementedError(
            'subclasses of CronBaseCommand must provide a task() method')
