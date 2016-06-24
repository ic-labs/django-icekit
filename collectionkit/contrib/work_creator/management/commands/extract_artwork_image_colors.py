from optparse import make_option
from django.db import models
from django.core.management.base import BaseCommand

from sfmoma.collection.models import ArtworkImage


class Command(BaseCommand):
    help = """Extract dominant colors for ArtworkImage.downloaded_image items
and store in ArtworkImage."""

    option_list = BaseCommand.option_list + (
        make_option(
            '--replace',
            action='store_true',
            dest='replace',
            help=('Replace colors even if they are already set, rather than'
                  ' skipping ArtworkImage records which already have colors')
        ),
    )

    def log(self, msg):
        if self.verbosity >= 1:
            print(msg)

    def handle(self, *args, **options):
        do_replace = options['replace']
        self.verbosity = int(options.get('verbosity', 1))

        # Process ArtworkImage records that have a download image
        for ai in ArtworkImage.objects.exclude(
            models.Q(downloaded_image__isnull=True) |
            models.Q(downloaded_image='')
        ):
            # Check whether ArtworkImage already has colors
            if ai._colors:
                if do_replace:
                    self.log("REPLACE colors for: %r" % ai)
                else:
                    self.log("SKIP item with extracted colors: %r" % ai)
                    continue  # Go to next item without extracting colors
            else:
                self.log("EXTRACT colors for: %r" % ai)
            # Do the work
            ai.extract_colors(save=True)
